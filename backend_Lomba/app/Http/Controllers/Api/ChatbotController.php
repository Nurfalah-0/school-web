<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Carbon\Carbon;
use App\Models\ChatbotConversation;
use App\Models\ChatbotMessage;
use App\Models\ChatbotKnowledgeBase;
use App\Models\AiApiLog;
use App\Helpers\SecurityHelper;

class ChatbotController extends Controller
{
    /**
     * Supported AI providers
     */
    private $aiProviders = [
        'openai' => [
            'name' => 'OpenAI',
            'models' => ['gpt-4', 'gpt-3.5-turbo'],
            'endpoint' => 'https://api.openai.com/v1/chat/completions',
        ],
        'anthropic' => [
            'name' => 'Anthropic Claude',
            'models' => ['claude-3-opus', 'claude-3-sonnet', 'claude-3-haiku'],
            'endpoint' => 'https://api.anthropic.com/v1/messages',
        ],
        'google' => [
            'name' => 'Google Gemini',
            'models' => ['gemini-pro'],
            'endpoint' => 'https://generativelanguage.googleapis.com/v1beta/models',
        ],
    ];

    /**
     * School context prompts
     */
    private $contextPrompts = [
        'general' => 'Anda adalah asisten virtual untuk SMK Nurul Jadid. Anda membantu menjawab pertanyaan tentang sekolah, program studi, PPDB, kegiatan sekolah, dan informasi umum lainnya. Jika butuh kontak langsung atau konfirmasi, hubungi WhatsApp resmi +6282335585491 atau email smknurja.paiton@gmail.com. Jawab dengan ramah dan informatif.',
        'ppdb' => 'Anda adalah asisten khusus PPDB SMK Nurul Jadid. Anda membantu calon siswa dan orang tua dengan informasi tentang pendaftaran, persyaratan, jalur masuk, jadwal, dan biaya pendidikan. Untuk konfirmasi atau pertanyaan langsung, arahkan ke WhatsApp resmi +6282335585491.',
        'academic' => 'Anda adalah asisten akademik SMK Nurul Jadid. Anda membantu dengan informasi tentang kurikulum, jadwal pelajaran, ujian, nilai, dan kegiatan akademik lainnya.',
        'bkk' => 'Anda adalah asisten Bursa Kerja Khusus SMK Nurul Jadid. Anda membantu dengan informasi tentang lowongan kerja, pelatihan, magang, dan karir setelah lulus.',
        'student' => 'Anda adalah asisten untuk siswa SMK Nurul Jadid. Anda membantu dengan informasi tentang kegiatan siswa, ekstrakurikuler, prestasi, dan kehidupan sekolah.',
    ];

    /**
     * Start new chatbot conversation
     */
    public function startConversation(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'context' => 'sometimes|in:general,ppdb,academic,bkk,student',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $user = $request->user();
            $context = $request->context ?? 'general';
            $sessionId = Str::uuid()->toString();

            $conversation = ChatbotConversation::create([
                'session_id' => $sessionId,
                'user_id' => $user?->id,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'context' => $context,
                'metadata' => [
                    'user_roles' => $user?->roles->pluck('name') ?? [],
                    'context_prompt' => $this->contextPrompts[$context],
                    'start_timestamp' => Carbon::now()->toDateTimeString(),
                ],
                'started_at' => Carbon::now(),
                'last_activity_at' => Carbon::now(),
                'is_active' => true,
            ]);

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'chatbot_conversation_started',
                'Chatbot conversation started: ' . $sessionId,
                $user?->id
            );

            return response()->json([
                'message' => 'Conversation started',
                'session_id' => $sessionId,
                'conversation' => $conversation,
                'context' => $context,
                'welcome_message' => $this->getWelcomeMessage($context),
            ], 201);

        } catch (\Exception $e) {
            Log::error('Chatbot conversation start error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat memulai percakapan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Send message to chatbot
     */
    public function sendMessage(Request $request, $sessionId)
    {
        $validator = Validator::make($request->all(), [
            'message' => 'required|string|min:1|max:1000',
            'context' => 'sometimes|in:general,ppdb,academic,bkk,student',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $user = $request->user();
            $message = SecurityHelper::sanitizeInput($request->message);
            $context = $request->context ?? 'general';

            // Cari conversation
            $conversation = ChatbotConversation::where('session_id', $sessionId)
                ->where('is_active', true)
                ->first();

            if (!$conversation) {
                return response()->json(['message' => 'Conversation tidak ditemukan atau sudah berakhir'], 404);
            }

            // Update last activity
            $conversation->update([
                'last_activity_at' => Carbon::now(),
                'context' => $context,
            ]);

            // Save user message
            $userMessage = ChatbotMessage::create([
                'conversation_id' => $conversation->id,
                'sender' => 'user',
                'message' => $message,
                'metadata' => [
                    'ip_address' => $request->ip(),
                    'user_agent' => $request->userAgent(),
                    'timestamp' => Carbon::now()->toDateTimeString(),
                ],
            ]);

            // Cek knowledge base terlebih dahulu
            $kbResponse = $this->checkKnowledgeBase($message, $context);

            if ($kbResponse) {
                // Gunakan response dari knowledge base
                $botResponse = $kbResponse;
                $aiModel = 'knowledge_base';
                $tokensUsed = 0;
                $responseTime = 0.1;
            } else {
                // Gunakan AI API
                $aiResponse = $this->callAiApi($message, $context, $conversation);
                $botResponse = $aiResponse['response'];
                $aiModel = $aiResponse['model'];
                $tokensUsed = $aiResponse['tokens_used'];
                $responseTime = $aiResponse['response_time'];
            }

            // Filter sensitive information dari response
            $botResponse = $this->filterSensitiveInfo($botResponse);

            // Save bot response
            $botMessage = ChatbotMessage::create([
                'conversation_id' => $conversation->id,
                'sender' => 'bot',
                'message' => $botResponse,
                'metadata' => [
                    'ai_model' => $aiModel,
                    'context_used' => $context,
                    'response_timestamp' => Carbon::now()->toDateTimeString(),
                ],
                'ai_model' => $aiModel,
                'tokens_used' => $tokensUsed,
                'response_time' => $responseTime,
                'message_type' => 'text',
            ]);

            // Update conversation message count
            $conversation->increment('message_count');

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'chatbot_message_sent',
                'Chatbot message sent: ' . substr($message, 0, 100),
                $user?->id
            );

            return response()->json([
                'message' => 'Message processed',
                'user_message' => $userMessage,
                'bot_response' => $botMessage,
                'conversation' => $conversation->fresh(),
                'from_knowledge_base' => !empty($kbResponse),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Chatbot send message error: ' . $e->getMessage(), [
                'session_id' => $sessionId,
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat memproses pesan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get conversation history
     */
    public function getConversationHistory($sessionId)
    {
        try {
            $conversation = ChatbotConversation::where('session_id', $sessionId)
                ->with(['messages' => function($query) {
                    $query->orderBy('created_at', 'asc');
                }])
                ->first();

            if (!$conversation) {
                return response()->json(['message' => 'Conversation tidak ditemukan'], 404);
            }

            return response()->json([
                'conversation' => $conversation,
                'messages' => $conversation->messages,
                'total_messages' => $conversation->messages->count(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Get conversation history error: ' . $e->getMessage(), [
                'session_id' => $sessionId,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil riwayat percakapan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * End conversation
     */
    public function endConversation(Request $request, $sessionId)
    {
        try {
            $user = $request->user();
            $conversation = ChatbotConversation::where('session_id', $sessionId)
                ->where('is_active', true)
                ->first();

            if (!$conversation) {
                return response()->json(['message' => 'Conversation tidak ditemukan atau sudah berakhir'], 404);
            }

            $conversation->update([
                'is_active' => false,
                'ended_at' => Carbon::now(),
                'metadata' => array_merge($conversation->metadata ?? [], [
                    'end_reason' => 'user_request',
                    'end_timestamp' => Carbon::now()->toDateTimeString(),
                ]),
            ]);

            // Log aktivitas
            SecurityHelper::logSecurityEvent(
                'chatbot_conversation_ended',
                'Chatbot conversation ended: ' . $sessionId,
                $user?->id
            );

            return response()->json([
                'message' => 'Conversation ended',
                'conversation' => $conversation,
                'summary' => [
                    'total_messages' => $conversation->message_count,
                    'duration' => $conversation->started_at->diffInMinutes($conversation->ended_at) . ' minutes',
                    'start_time' => $conversation->started_at->toDateTimeString(),
                    'end_time' => $conversation->ended_at->toDateTimeString(),
                ],
            ], 200);

        } catch (\Exception $e) {
            Log::error('End conversation error: ' . $e->getMessage(), [
                'session_id' => $sessionId,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengakhiri percakapan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Search knowledge base
     */
    public function searchKnowledgeBase(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'query' => 'required|string|min:1|max:500',
            'category' => 'sometimes|string',
            'limit' => 'sometimes|integer|min:1|max:50',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $query = $request->query;
            $category = $request->category;
            $limit = $request->limit ?? 10;

            $searchQuery = ChatbotKnowledgeBase::where('is_active', true)
                ->where(function($q) use ($query) {
                    $q->where('question', 'like', "%{$query}%")
                      ->orWhere('answer', 'like', "%{$query}%");
                });

            if ($category) {
                $searchQuery->where('category', $category);
            }

            $results = $searchQuery->orderBy('priority', 'desc')
                ->orderBy('usage_count', 'desc')
                ->limit($limit)
                ->get();

            // Increment usage count untuk hasil yang ditemukan
            foreach ($results as $result) {
                $result->increment('usage_count');
                $result->update(['last_used_at' => Carbon::now()]);
            }

            return response()->json([
                'query' => $query,
                'results' => $results,
                'total' => $results->count(),
                'categories' => $this->getKnowledgeBaseCategories(),
            ], 200);

        } catch (\Exception $e) {
            Log::error('Knowledge base search error: ' . $e->getMessage(), [
                'query' => $request->query,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mencari knowledge base',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get chatbot statistics
     */
    public function getStatistics(Request $request)
    {
        try {
            $user = $request->user();

            // Hanya admin yang bisa melihat statistik
            if (!$user->hasAnyRole(['superadmin', 'admin_sekolah'])) {
                return response()->json(['message' => 'Anda tidak memiliki izin untuk melihat statistik'], 403);
            }

            $timeRange = $request->time_range ?? '30d'; // 7d, 30d, 90d
            $startDate = Carbon::now()->subDays((int)$timeRange);

            $stats = [
                'total_conversations' => ChatbotConversation::count(),
                'active_conversations' => ChatbotConversation::where('is_active', true)->count(),
                'total_messages' => ChatbotMessage::count(),
                'messages_today' => ChatbotMessage::whereDate('created_at', Carbon::today())->count(),
                'total_users' => ChatbotConversation::distinct('user_id')->count('user_id'),
                'popular_contexts' => ChatbotConversation::selectRaw('context, count(*) as count')
                    ->groupBy('context')
                    ->orderBy('count', 'desc')
                    ->limit(5)
                    ->get(),
                'ai_usage' => AiApiLog::selectRaw('api_provider, count(*) as request_count, sum(tokens_used) as total_tokens, avg(response_time) as avg_response_time')
                    ->where('created_at', '>=', $startDate)
                    ->groupBy('api_provider')
                    ->get(),
                'knowledge_base_stats' => [
                    'total_entries' => ChatbotKnowledgeBase::count(),
                    'active_entries' => ChatbotKnowledgeBase::where('is_active', true)->count(),
                    'most_used' => ChatbotKnowledgeBase::orderBy('usage_count', 'desc')
                        ->limit(10)
                        ->get(['id', 'question', 'usage_count']),
                ],
            ];

            return response()->json($stats, 200);

        } catch (\Exception $e) {
            Log::error('Get chatbot statistics error: ' . $e->getMessage(), [
                'user_id' => $request->user()?->id,
                'error' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'message' => 'Terjadi kesalahan saat mengambil statistik',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Helper methods
     */

    private function getWelcomeMessage($context)
    {
        $messages = [
            'general' => 'Halo! Saya asisten virtual SMK Nurul Jadid. Ada yang bisa saya bantu?',
            'ppdb' => 'Halo! Saya asisten PPDB SMK Nurul Jadid. Siap membantu dengan informasi pendaftaran dan persyaratan.',
            'academic' => 'Halo! Saya asisten akademik SMK Nurul Jadid. Ada pertanyaan tentang pelajaran atau kegiatan akademik?',
            'bkk' => 'Halo! Saya asisten BKK SMK Nurul Jadid. Siap membantu dengan informasi lowongan kerja dan karir.',
            'student' => 'Halo! Saya asisten untuk siswa SMK Nurul Jadid. Ada yang bisa saya bantu hari ini?',
        ];

        return $messages[$context] ?? $messages['general'];
    }

    private function checkKnowledgeBase($query, $context)
    {
        try {
            // Cari di knowledge base berdasarkan similarity
            $kbEntries = ChatbotKnowledgeBase::where('is_active', true)
                ->where('category', 'like', "%{$context}%")
                ->get();

            $bestMatch = null;
            $bestScore = 0;

            foreach ($kbEntries as $entry) {
                $score = $this->calculateSimilarity($query, $entry->question);

                // Cek keywords
                if ($entry->keywords) {
                    foreach ($entry->keywords as $keyword) {
                        if (stripos($query, $keyword) !== false) {
                            $score += 0.3; // Bonus untuk keyword match
                        }
                    }
                }

                if ($score > $bestScore && $score > 0.5) { // Threshold similarity
                    $bestScore = $score;
                    $bestMatch = $entry;
                }
            }

            if ($bestMatch) {
                // Format response dari knowledge base
                return "Berdasarkan informasi yang ada: \n\n" . $bestMatch->answer;
            }

            return null;

        } catch (\Exception $e) {
            Log::error('Knowledge base check error: ' . $e->getMessage());
            return null;
        }
    }

    private function calculateSimilarity($str1, $str2)
    {
        $str1 = strtolower($str1);
        $str2 = strtolower($str2);

        similar_text($str1, $str2, $percent);
        return $percent / 100;
    }

    private function callAiApi($message, $context, $conversation)
    {
        $startTime = microtime(true);

        try {
            // Pilih AI provider (bisa dikonfigurasi)
            $provider = config('app.ai_provider', 'openai');
            $apiKey = config('app.ai_api_key');

            if (!$apiKey) {
                throw new \Exception('AI API key not configured');
            }

            // Prepare prompt dengan context
            $systemPrompt = $this->contextPrompts[$context] ?? $this->contextPrompts['general'];

            // Tambahkan conversation history
            $history = $this->getConversationHistoryForApi($conversation->id, 5);

            $messages = [
                ['role' => 'system', 'content' => $systemPrompt],
            ];

            // Add history
            foreach ($history as $msg) {
                $messages[] = [
                    'role' => $msg['sender'] === 'user' ? 'user' : 'assistant',
                    'content' => $msg['message'],
                ];
            }

            // Add current message
            $messages[] = ['role' => 'user', 'content' => $message];

            // Call AI API
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $apiKey,
                'Content-Type' => 'application/json',
                'anthropic-version' => '2023-06-01', // Untuk Anthropic
            ])->timeout(30)->post($this->aiProviders[$provider]['endpoint'], [
                'model' => $this->aiProviders[$provider]['models'][0],
                'messages' => $messages,
                'max_tokens' => 1000,
                'temperature' => 0.7,
            ]);

            $responseTime = microtime(true) - $startTime;

            if ($response->failed()) {
                throw new \Exception('AI API request failed: ' . $response->body());
            }

            $responseData = $response->json();

            // Parse response berdasarkan provider
            $aiResponse = '';
            $tokensUsed = 0;

            switch ($provider) {
                case 'openai':
                    $aiResponse = $responseData['choices'][0]['message']['content'] ?? '';
                    $tokensUsed = $responseData['usage']['total_tokens'] ?? 0;
                    break;
                case 'anthropic':
                    $aiResponse = $responseData['content'][0]['text'] ?? '';
                    $tokensUsed = $responseData['usage']['input_tokens'] + $responseData['usage']['output_tokens'] ?? 0;
                    break;
                case 'google':
                    $aiResponse = $responseData['candidates'][0]['content']['parts'][0]['text'] ?? '';
                    $tokensUsed = 0; // Google mungkin tidak return token count
                    break;
            }

            // Log API call
            AiApiLog::create([
                'api_provider' => $provider,
                'endpoint' => 'chat/completion',
                'request_data' => ['messages' => $messages, 'model' => $this->aiProviders[$provider]['models'][0]],
                'response_data' => ['response' => substr($aiResponse, 0, 500)], // Simpan sebagian saja
                'status_code' => $response->status(),
                'response_time' => $responseTime,
                'tokens_used' => $tokensUsed,
                'cost' => $this->calculateApiCost($provider, $tokensUsed),
                'user_id' => $conversation->user_id,
                'ip_address' => request()->ip(),
            ]);

            return [
                'response' => $aiResponse,
                'model' => $this->aiProviders[$provider]['models'][0],
                'tokens_used' => $tokensUsed,
                'response_time' => $responseTime,
                'provider' => $provider,
            ];

        } catch (\Exception $e) {
            $responseTime = microtime(true) - $startTime;

            // Log error
            AiApiLog::create([
                'api_provider' => $provider ?? 'unknown',
                'endpoint' => 'chat/completion',
                'request_data' => ['message' => substr($message, 0, 200)],
                'response_data' => null,
                'status_code' => 500,
                'response_time' => $responseTime,
                'tokens_used' => 0,
                'cost' => 0,
                'user_id' => $conversation->user_id,
                'ip_address' => request()->ip(),
                'error_message' => $e->getMessage(),
            ]);

            // Fallback response
            return [
                'response' => 'Maaf, terjadi kesalahan saat memproses pertanyaan Anda. Silakan coba lagi nanti atau hubungi admin sekolah.',
                'model' => 'fallback',
                'tokens_used' => 0,
                'response_time' => $responseTime,
                'provider' => 'fallback',
            ];
        }
    }

    private function getConversationHistoryForApi($conversationId, $limit = 5)
    {
        return ChatbotMessage::where('conversation_id', $conversationId)
            ->orderBy('created_at', 'desc')
            ->limit($limit * 2) // Ambil lebih banyak karena ada user dan bot messages
            ->get(['sender', 'message'])
            ->reverse()
            ->values()
            ->toArray();
    }

    private function calculateApiCost($provider, $tokens)
    {
        // Harga per 1K tokens (contoh)
        $prices = [
            'openai' => [
                'gpt-4' => 0.03, // $0.03 per 1K tokens
                'gpt-3.5-turbo' => 0.0015,
            ],
            'anthropic' => [
                'claude-3-opus' => 0.075,
                'claude-3-sonnet' => 0.015,
                'claude-3-haiku' => 0.001,
            ],
            'google' => [
                'gemini-pro' => 0.0005,
            ],
        ];

        // Default ke harga terendah jika tidak ditemukan
        $pricePer1K = 0.001;

        foreach ($prices as $providerName => $models) {
            if ($providerName === $provider) {
                $pricePer1K = $models[array_key_first($models)] ?? 0.001;
                break;
            }
        }

        return ($tokens / 1000) * $pricePer1K;
    }

    private function filterSensitiveInfo($text)
    {
        // Simpan kontak resmi sekolah agar tidak terfilter
        $officialPlaceholders = [
            '+6282335585491' => '__OFFICIAL_WA_1__',
            '+62 823-3558-5491' => '__OFFICIAL_WA_2__',
            '082335585491' => '__OFFICIAL_WA_3__',
            'smknurja.paiton@gmail.com' => '__OFFICIAL_EMAIL_1__',
            'info@smknuruljadid.sch.id' => '__OFFICIAL_EMAIL_2__',
        ];

        foreach ($officialPlaceholders as $real => $token) {
            $text = str_replace($real, $token, $text);
        }

        // Filter informasi sensitif seperti nomor telepon pribadi, email, dll.
        $patterns = [
            // Phone numbers
            '/(\+62|62|0)\d{9,12}/' => '[NOMOR TELEPON]',
            // Email addresses
            '/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/' => '[EMAIL]',
            // NISN/NIS
            '/\b\d{10}\b/' => '[NISN]',
            '/\b\d{8}\b/' => '[NIS]',
        ];

        foreach ($patterns as $pattern => $replacement) {
            $text = preg_replace($pattern, $replacement, $text);
        }

        // Kembalikan kontak resmi
        foreach ($officialPlaceholders as $real => $token) {
            $text = str_replace($token, $real, $text);
        }

        return $text;
    }

    private function getKnowledgeBaseCategories()
    {
        return ChatbotKnowledgeBase::distinct('category')
            ->where('is_active', true)
            ->pluck('category')
            ->toArray();
    }
}

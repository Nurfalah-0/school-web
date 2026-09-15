<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class ContactController extends Controller
{
    public function send(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:191'],
            'recipient' => ['required', 'in:admin,staff'],
            'subject' => ['required', 'string', 'max:150'],
            'message' => ['required', 'string', 'max:5000'],
        ]);

        $recipient = config("services.contact.{$validated['recipient']}_email");
        $body = "Nama: {$validated['name']}\n"
            . "Email: {$validated['email']}\n"
            . "Tujuan: " . ($validated['recipient'] === 'admin' ? 'Admin' : 'Staf') . "\n\n"
            . $validated['message'];

        Mail::raw($body, function ($mail) use ($validated, $recipient) {
            $mail->to($recipient)
                ->replyTo($validated['email'], $validated['name'])
                ->subject('[Contact Website] ' . $validated['subject']);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pesan berhasil dikirim. Tim kami akan segera menghubungi Anda.',
        ]);
    }
}
import { ElMessage } from 'element-plus';
import 'element-plus/dist/index.css';

export default {
  install(app) {
    app.config.globalProperties.$message = ElMessage;
  },
};

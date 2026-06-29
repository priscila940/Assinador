const express = require('express');
const multer = require('multer');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const app = express();
const upload = multer({ dest: 'uploads/' });

app.use(express.static('public'));
app.use('/assinados', express.static('assinados'));

app.post('/assinar', upload.single('ipa'), (req, res) => {
    if (!req.file) return res.status(400).json({ success: false, error: 'Nenhum arquivo enviado.' });

    const fileId = Date.now().toString();
    const inputPath = req.file.path;
    const outputPath = path.join(__dirname, 'assinados', `${fileId}.ipa`);
    
    const certPath = path.join(__dirname, 'certificados', 'certificado.p12');
    const provisionPath = path.join(__dirname, 'certificados', 'profile.mobileprovision');
    const certPassword = 'SUA_SENHA_DO_CERTIFICADO'; 

    const command = `zsign -k "${certPath}" -p "${certPassword}" -m "${provisionPath}" -o "${outputPath}" "${inputPath}"`;

    exec(command, (error, stdout, stderr) => {
        if (fs.existsSync(inputPath)) fs.unlinkSync(inputPath);

        if (error) {
            return res.json({ success: false, error: 'Falha na assinatura do binário.' });
        }

        const plistContent = `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>https://${req.get('host')}/assinados/${fileId}.ipa</string>
                </dict>
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>com.assinador.auto</string>
                <key>bundle-version</key>
                <string>1.0</string>
                <key>kind</key>
                <string>software</string>
                <key>title</key>
                <string>App Assinado</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>`;

        if (!fs.existsSync('public/manifests')) fs.mkdirSync('public/manifests', { recursive: true });
        if (!fs.existsSync('assinados')) fs.mkdirSync('assinados', { recursive: true });
        
        fs.writeFileSync(`public/manifests/${fileId}.plist`, plistContent);
        res.json({ success: true, id: fileId });
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor ativo na porta ${PORT}`));

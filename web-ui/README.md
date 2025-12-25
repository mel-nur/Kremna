# 🌐 Web Arayüzü Kullanım Kılavuzu

## 🚀 Başlatma

### 1. Sunucuları Çalıştır

**Terminal 1 - Main Sunucu:**
```powershell
cd main
..\.venv\Scripts\python.exe main_receiver.py
```

**Terminal 2 - Port Yönetimi:**
```powershell
cd "port-yönetimi"
..\.venv\Scripts\python.exe local_api_server.py
```

### 2. Web Arayüzünü Aç

`web-ui/chatbot.html` dosyasını tarayıcıda aç:
- Dosyaya sağ tıkla → "Open with" → Tarayıcını seç
- Veya dosya yolunu tarayıcıya yapıştır

## ✨ Özellikler

✅ **Modern Tasarım**: Gradient renkler ve smooth animasyonlar  
✅ **Türkçe Karakter Desteği**: UTF-8 encoding ile tam destek  
✅ **Gerçek Zamanlı Sohbet**: Typing indicator ile canlı deneyim  
✅ **Metadata Gösterimi**: Konu tespiti, token kullanımı, engelleme durumu  
✅ **Chat History**: Sohbet geçmişi otomatik yönetimi  
✅ **Responsive**: Mobil ve masaüstü uyumlu  

## 🎨 Arayüz Özellikleri

### Mesaj Gösterimi
- **Kullanıcı Mesajları**: Sağ tarafta, mor gradient arka plan
- **AI Yanıtları**: Sol tarafta, beyaz arka plan
- **Metadata**: Her AI yanıtının altında konu, token ve durum bilgisi

### Konu Tespiti
- 🔴 `fiyat_itirazi`: Fiyat, ücret, para, maliyet
- 🟢 `garanti_sorgusu`: Garanti, destek, servis
- 🔵 `urun_bilgisi`: Ürün, kalite, malzeme
- ⚪ `genel`: Diğer konular

## 🔧 Yapılandırma

### Agent ID ve Session ID Değiştirme

`chatbot.html` dosyasında şu satırları düzenle:

```html
<span id="agentId">agent_8823_xyz</span>
<span id="sessionId">sess_user_999</span>
```

### API URL Değiştirme

JavaScript kısmında:

```javascript
const API_URL = 'http://localhost:9000/chat';
```

## 📸 Ekran Görüntüsü

```
┌─────────────────────────────────────┐
│  🤖 Premium Müşteri Temsilcisi      │
│  Size nasıl yardımcı olabilirim?    │
├─────────────────────────────────────┤
│  Agent ID: agent_8823_xyz           │
│  Session ID: sess_user_999          │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────┐        │
│  │ Merhaba! Ben Premium    │        │
│  │ Müşteri Temsilcinizim.  │        │
│  └─────────────────────────┘        │
│                                     │
│        ┌─────────────────────┐      │
│        │ Fiyatlarınız neden  │      │
│        │ bu kadar yüksek?    │      │
│        └─────────────────────┘      │
│                                     │
│  ┌─────────────────────────┐        │
│  │ Değerli müşterimiz...   │        │
│  │ 📊 Konu: fiyat_itirazi  │        │
│  │ 🔢 Token: 850           │        │
│  │ ✅ Onaylandı            │        │
│  └─────────────────────────┘        │
│                                     │
├─────────────────────────────────────┤
│  [Mesajınızı yazın...]    [Gönder] │
└─────────────────────────────────────┘
```

## 🐛 Sorun Giderme

### CORS Hatası
Eğer tarayıcı konsolunda CORS hatası görüyorsan:
- Main sunucunun CORS middleware'i aktif olduğundan emin ol
- Sunucuyu yeniden başlat

### Bağlantı Hatası
- Main sunucunun port 9000'de çalıştığından emin ol
- `http://localhost:9000/chat` adresine erişilebildiğini kontrol et

### Türkçe Karakter Sorunu
- Tarayıcı UTF-8 encoding kullanıyor, sorun olmamalı
- Eğer sorun varsa, tarayıcı geliştirici araçlarında Network sekmesini kontrol et

## 🎯 Örnek Kullanım

1. Tarayıcıda `chatbot.html` dosyasını aç
2. "Fiyatlarınız neden bu kadar yüksek?" yaz
3. Gönder butonuna tıkla
4. AI yanıtını ve metadata'yı gör
5. Sohbete devam et!

---

**Not**: Bu arayüz development amaçlıdır. Production kullanımı için güvenlik önlemleri eklenmelidir.

# 🚀 PostgreSQL Migration Guide - Railway

## ❌ Problem: SQLite ile Veri Kaybı

SQLite dosya tabanlıdır ve her Railway deploy'da container sıfırlanır:
```
Deploy → Yeni Container → Eski .db dosyası yok → Veriler kayboluyor ❌
```

## ✅ Çözüm: Railway PostgreSQL

PostgreSQL ayrı bir servis olarak çalışır ve container'dan bağımsızdır.

---

## 📋 Adımlar

### 1. Railway Dashboard'a Git
👉 https://railway.app/dashboard

### 2. PostgreSQL Ekle
1. Projenize tıklayın (**AI-CORE**)
2. **"+ New"** butonuna tıklayın
3. **"Database"** seçeneğini seçin
4. **"PostgreSQL"** seçin
5. Railway otomatik olarak PostgreSQL servisini oluşturacak ✅

### 3. DATABASE_URL'i AI-CORE Servisine Bağla
1. **AI-CORE** servisine tıklayın (sol menüden)
2. **"Variables"** sekmesine gidin
3. **"+ New Variable"** butonuna tıklayın
4. **"Add a Reference"** seçeneğini seçin
5. PostgreSQL servisinin **DATABASE_URL** değişkenini seçin
6. **"Add"** butonuna tıklayın ✅

### 4. Kodu Deploy Et
```bash
git add .
git commit -m "Migrate from SQLite to PostgreSQL"
git push
```

Railway otomatik olarak yeni kodu deploy edecek ve PostgreSQL'e bağlanacak! 🎉

---

## 🔍 Doğrulama

### Railway Logs'u Kontrol Et:
```
Railway Dashboard → AI-CORE → Deployments → Son deploy → Logs
```

Şunu görmelisin:
```
✅ Connected to PostgreSQL
✅ Tables created successfully
```

### Test Et:
```bash
# Agent kaydet
curl -X POST https://your-app.railway.app/agent_config \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "test_agent_123",
    "persona_title": "Test Agent",
    "model_instructions": {
      "tone": "Friendly",
      "rules": ["Be helpful"]
    }
  }'

# Deploy sonrası agent'ın hala orada olduğunu kontrol et
curl https://your-app.railway.app/chat \
  -H "Content-Type: application/json" \
  -d '{
    "agent_id": "test_agent_123",
    "user_message": "Hello"
  }'
```

---

## 📊 Yapılan Kod Değişiklikleri

### ✅ Güncellenmiş Dosyalar:

1. **requirements.txt**
   - ✅ `psycopg2-binary` eklendi (PostgreSQL driver)
   - ✅ `SQLAlchemy` eklendi (ORM)

2. **main/main_receiver.py**
   - ✅ SQLite → PostgreSQL/SQLAlchemy geçişi
   - ✅ `DATABASE_URL` environment variable desteği
   - ✅ Railway PostgreSQL URL format düzeltmesi
   - ✅ Local development için SQLite fallback

### 🔄 Geriye Dönük Uyumluluk:
- ✅ Eski API formatları çalışmaya devam ediyor
- ✅ Local development için SQLite hala kullanılabiliyor (DATABASE_URL yoksa)
- ✅ Tüm endpoint'ler aynı şekilde çalışıyor

---

## 🎯 Sonuç

✅ Her deploy'da veriler korunuyor  
✅ Agent'lar kaybolmuyor  
✅ Judge projesi test yapabiliyor  
✅ Production-ready PostgreSQL kullanımı

---

## 🆘 Sorun Giderme

### "relation does not exist" hatası:
```
✅ Tablolar otomatik oluşturulur, endişelenme!
İlk request'te SQLAlchemy tablolarını oluşturacak.
```

### DATABASE_URL bulunamıyor:
```
1. Railway Dashboard → AI-CORE → Variables
2. DATABASE_URL olduğunu kontrol et
3. Yoksa tekrar "Add Reference" yap
```

### Bağlantı hatası:
```
Railway PostgreSQL servisinin çalıştığını kontrol et:
Dashboard → PostgreSQL → Status: Running ✅
```

---

**🎉 Artık Railway'de kalıcı veritabanınız var!**

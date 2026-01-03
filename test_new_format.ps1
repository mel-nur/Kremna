# Test Script - Yeni JSON Formati

# UTF-8 encoding ayarla
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Yeni JSON Format Testi ===" -ForegroundColor Cyan

# Test 1: Dashboard'dan Agent Konfigurasyonu Kaydet
Write-Host "`n[TEST 1] Agent konfigurasyonu kaydediliyor..." -ForegroundColor Yellow

$agentConfigData = @{
    endpoint = "/agent_config"
    agentId = "agent_8823_xyz"
    persona_title = "Premium Musteri Temsilcisi"
    model_instructions = @{
        tone = "Resmi, Saygili ve Cozum Odakli"
        rules = @(
            "Cevaplar 4 cumleyi gecmemelidir.",
            "Fiyatlar hakkinda savunmaci degil, deger odakli konusulmalidir.",
            "Tum cevaplar cumlenin sonunda 'Saygilarimla.' ifadesiyle bitmelidir."
        )
        prohibited_topics = @("Rakiplerin fiyatlari", "Siyasi gorusler")
    }
    initial_context = @{
        company_slogan = "Kalite Asla Tesaduf Degildir."
        pricing_rationale = "Yuksek fiyatlandirmamiz, kullanilan birinci sinif malzemeler ve kapsamli garanti hizmetlerimizle dogrudan iliskilidir."
    }
} | ConvertTo-Json -Depth 5

try {
    $configResponse = Invoke-RestMethod -Uri "http://localhost:8000/send_json" -Method Post -Body $agentConfigData -ContentType "application/json"
    Write-Host "Agent konfigurasyonu kaydedildi!" -ForegroundColor Green
    Write-Host "Response: $($configResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
}
catch {
    Write-Host "Konfigurasyon kaydedilemedi: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Chat Core'dan Mesaj Gonder (Ilk Mesaj)
Write-Host "`n[TEST 2] Chat Core'dan ilk mesaj gonderiliyor..." -ForegroundColor Yellow

$chatData1 = @{
    endpoint = "/chat"
    agent_id = "agent_8823_xyz"
    session_id = "sess_user_999"
    user_message = "Fiyatlariniz neden bu kadar yuksek?"
    chat_history = @()
} | ConvertTo-Json -Depth 3

try {
    $chatResponse1 = Invoke-RestMethod -Uri "http://localhost:8000/send_json" -Method Post -Body $chatData1 -ContentType "application/json"
    Write-Host "Ilk mesaj gonderildi!" -ForegroundColor Green
    Write-Host "AI Cevabi: $($chatResponse1.main_response.reply)" -ForegroundColor Magenta
    Write-Host "Metadata: $($chatResponse1.main_response.metadata | ConvertTo-Json)" -ForegroundColor Gray
    $firstResponse = $chatResponse1.main_response.reply
}
catch {
    Write-Host "Mesaj gonderilemedi: $_" -ForegroundColor Red
    exit 1
}

# Test 3: Chat Core'dan Gecmisli Mesaj Gonder
Write-Host "`n[TEST 3] Chat Core'dan gecmisli mesaj gonderiliyor..." -ForegroundColor Yellow

$chatData2 = @{
    endpoint = "/chat"
    agent_id = "agent_8823_xyz"
    session_id = "sess_user_999"
    user_message = "Peki garanti suresini uzatabilir misiniz?"
    chat_history = @(
        @{
            role = "user"
            content = "Fiyatlariniz neden bu kadar yuksek?"
        },
        @{
            role = "assistant"
            content = $firstResponse
        }
    )
} | ConvertTo-Json -Depth 4

try {
    $chatResponse2 = Invoke-RestMethod -Uri "http://localhost:8000/send_json" -Method Post -Body $chatData2 -ContentType "application/json"
    Write-Host "Gecmisli mesaj gonderildi!" -ForegroundColor Green
    Write-Host "AI Cevabi: $($chatResponse2.main_response.reply)" -ForegroundColor Magenta
    Write-Host "Metadata: $($chatResponse2.main_response.metadata | ConvertTo-Json)" -ForegroundColor Gray
    
    # Cevabin "Saygilarimla" icerip icermedigini kontrol et
    if ($chatResponse2.main_response.reply -match "Saygilarimla") {
        Write-Host "AI kurallara uydu! (Saygilarimla ile bitti)" -ForegroundColor Green
    }
    else {
        Write-Host "AI kurallara uymadi (beklenmeyen durum)" -ForegroundColor Yellow
    }
    
    # Metadata kontrolu
    if ($chatResponse2.main_response.metadata.blocked -eq $false) {
        Write-Host "Yasakli konu tespit edilmedi" -ForegroundColor Green
    }
    Write-Host "Tespit edilen konu: $($chatResponse2.main_response.metadata.topic_detected)" -ForegroundColor Cyan
}
catch {
    Write-Host "Gecmisli mesaj gonderilemedi: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Tum Testler Tamamlandi ===" -ForegroundColor Cyan
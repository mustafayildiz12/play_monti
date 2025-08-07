import json

# Örnek olarak json'u bir dosyada tuttuğunu varsayalım:
with open("48-60.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# data bir liste ise:
for i, item in enumerate(data, 1):  # 1'den başlatmak için
    item["day"] = i

# Sonucu tekrar dosyaya yazalım:
with open("48-60_fixed.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

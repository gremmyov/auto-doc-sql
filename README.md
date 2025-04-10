# Auto-Doc SQL

Skrypt SQL do automatycznego tworzenia dokumentów "ZA" w systemie sprzedażowym.

## Co robi?
- Tworzy dokument na podstawie braków magazynowych
- Bierze pod uwagę historię sprzedaży z ostatnich 2 dni
- Wybiera tylko produkty oznaczone jako "ZAMÓW"

## Wymagania
- SQL Server
- Tabela `Tranhead`, `TranElem`, `Magazyn`, `Indeksy` 

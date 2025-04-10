SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

DECLARE @NowyId INT;

INSERT INTO Tranhead (
    Rok, Typ, Numer, Seria, DataTransakcji, DataDokumentu, DataVAT,
    DokumentObcy, Zap³ata, Termin, Finalny, CzyHurt, Rabat,
    Netto, VAT, Netto1, VAT1, Zap³acono, Fiskalny, Blokada,
    Waluta, Kurs, Kraj, Filia, Oznaczenie
)
SELECT 
    YEAR(GETDATE()), 'ZA', ISNULL(MAX(Numer), 0) + 1, '', GETDATE(), GETDATE(), GETDATE(),
    '', '', 7, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 0,
    'PLN', 1, 0, 1, 0
FROM Tranhead
WHERE Typ = 'ZA';

SET @NowyId = SCOPE_IDENTITY();

INSERT INTO TranElem (
    Pozycja, KodTowaru, Nazwa, Jm, Iloœæ, Cena, Wa¿ona, Korekta, VAT, Cennik, Towar, DataZmiany, Id
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY m.KodTowaru), m.KodTowaru, m.Nazwa, m.Jm, 1, m.Hurt, m.Wa¿ona, 0, m.VAT, m.Hurt, 1, GETDATE(), @NowyId
FROM Magazyn m
JOIN Indeksy i ON i.KodTowaru = m.KodTowaru
WHERE 
    i.Rodzaj = 'ZAMÓW'
    AND m.Stan < m.StanMin
    AND EXISTS (
        SELECT 1 
        FROM TranElem te 
        JOIN Tranhead th ON te.Id = th.Id
        WHERE 
            te.KodTowaru = m.KodTowaru
            AND th.Typ IN ('FA', 'PA')
            AND th.DataDokumentu >= DATEADD(DAY, -2, GETDATE())
    );

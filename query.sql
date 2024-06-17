/* 1.
Con riferimento ad una base di dati sullo schema

CREATE TABLE passeggero (
    id_passeggero integer NOT NULL,
    id_prenotazione integer NOT NULL,
    codice_prenotazione text ,
    numero_passeggero integer,
    nome text  NOT NULL,
    cognome text  NOT NULL,
    id_utente integer,
    eta integer,
    CONSTRAINT passenger_pkey PRIMARY KEY (id_passeggero))

scrivere l'interrogazione SQL che trova nome, cognome ed età dei passeggeri più giovani, ordinati per nome e cognome.
*/

SELECT DISTINCT nome, cognome, eta
FROM passeggero
WHERE 
    eta = (
        SELECT MIN(p.eta)
        FROM passeggero p
    )
ORDER BY nome, cognome ASC;

/* 2.
Con riferimento ad una base di dati sullo schema:
CREATE TABLE volo (
    numero_volo text  NOT NULL,
    aeroporto_partenza character(3),
    aeroporto_arrivo character(3) ,
    orario_partenza_previsto time ,
    orario_arrivo_previsto time ,
    CONSTRAINT flight_pkey1 PRIMARY KEY (numero_volo)
)

CREATE TABLE IF NOT EXISTS volo_reale(
    id_volo_reale integer NOT NULL,
    data_partenza_programmata date,
    numero_volo text ,
    codice_tipo_aeromobile character(3) ,
    data_partenza_reale date,
    data_arrivo_reale date,
    orario_arrivo_reale time ,
    orario_partenza_reale time ,
    CONSTRAINT new_actual_flight_pkey PRIMARY KEY (id_volo_reale),
    CONSTRAINT flight_no_date_unique UNIQUE (numero_volo, data_partenza_programmata),
    CONSTRAINT fk_actual_flight_flight FOREIGN KEY (numero_volo)
        REFERENCES volo (numero_volo))

Scrivere l'interrogazione SQL che restituisce quanti voli sono partiti in ritardo dall'aeroporto con codice "ATL" il '2023-07-05'. Un volo è considerato in ritardo se l'orario di partenza reale è maggiore dell'orario di partenza previsto
*/

SELECT COUNT(DISTINCT v.numero_volo ) AS num_voli_ritardo
FROM volo_reale vr
    JOIN volo v ON vr.numero_volo = v.numero_volo
WHERE 
    v.aeroporto_partenza LIKE 'ATL' AND 
    vr.data_partenza_programmata LIKE '2023-07-05' AND
    vr.orario_partenza_reale  > v.orario_partenza_previsto;

/* 3.
Con riferimento ad una base di dati sullo schema:
CREATE TABLE volo (
    numero_volo text  NOT NULL,
    aeroporto_partenza character(3),
    aeroporto_arrivo character(3) ,
    orario_partenza_previsto time ,
    orario_arrivo_previsto time ,
    CONSTRAINT flight_pkey1 PRIMARY KEY (numero_volo)
)

CREATE TABLE IF NOT EXISTS volo_reale(
    id_volo_reale integer NOT NULL,
    data_partenza_programmata date,
    numero_volo text ,
    codice_tipo_aeromobile character(3) ,
    data_partenza_reale date,
    data_arrivo_reale date,
    orario_arrivo_reale time ,
    orario_partenza_reale time ,
    CONSTRAINT new_actual_flight_pkey PRIMARY KEY (id_volo_reale),
    CONSTRAINT flight_no_date_unique UNIQUE (numero_volo, data_partenza_programmata),
    CONSTRAINT fk_actual_flight_flight FOREIGN KEY (numero_volo)
        REFERENCES volo (numero_volo))

Scrivere l'interrogazione SQL che trova il codice degli aeroporti con il maggior numero di voli in ritardo. Mostrare codice dell'aeroporto e numero di voli in ritardo, ordinati per codice dell'aeroporto e numero di voli in ritardo

*/

CREATE VIEW IF NOT EXISTS aeroporto2ritardi AS 
    SELECT v.aeroporto_partenza, COUNT(DISTINCT vr.id_volo_reale ) AS numero_ritardi
    FROM volo_reale vr
        JOIN volo v ON vr.numero_volo = v.numero_volo
    WHERE 
        vr.orario_partenza_reale  > v.orario_partenza_previsto
    GROUP BY v.aeroporto_partenza;


SELECT aeroporto_partenza, numero_ritardi
FROM aeroporto2ritardi
WHERE 
    numero_ritardi >= (
        SELECT MAX(a2r.numero_ritardi)
        FROM aeroporto2ritardi a2r
    )
ORDER BY aeroporto_partenza, numero_ritardi ASC;

/* 4.
Con riferimento ad una base di dati sullo schema:
CREATE TABLE volo (
    numero_volo text  NOT NULL,
    aeroporto_partenza character(3),
    aeroporto_arrivo character(3) ,
    orario_partenza_previsto time ,
    orario_arrivo_previsto time ,
    CONSTRAINT flight_pkey1 PRIMARY KEY (numero_volo)
)

CREATE TABLE IF NOT EXISTS volo_reale(
    id_volo_reale integer NOT NULL,
    data_partenza_programmata date,
    numero_volo text ,
    codice_tipo_aeromobile character(3) ,
    data_partenza_reale date,
    data_arrivo_reale date,
    orario_arrivo_reale time ,
    orario_partenza_reale time ,
    CONSTRAINT new_actual_flight_pkey PRIMARY KEY (id_volo_reale),
    CONSTRAINT flight_no_date_unique UNIQUE (numero_volo, data_partenza_programmata),
    CONSTRAINT fk_actual_flight_flight FOREIGN KEY (numero_volo)
        REFERENCES volo (numero_volo))

Scrivere l'interrogazione SQL che, per ogni aeroporto di partenza, trova orario e numero del volo reale partito più tardi il giorno '2023-07-04'. Mostrare codice aeroporto, numero volo, orario, ordinati per codice aeroporto, numero volo, orario
*/

SELECT DISTINCT v.aeroporto_partenza, vr.orario_partenza_reale  AS ultimo_orario, vr.numero_volo 
FROM volo v 
    JOIN volo_reale vr ON v.numero_volo = vr.numero_volo
WHERE vr.data_partenza_reale = '2023-07-04'
GROUP BY v.aeroporto_partenza
HAVING vr.orario_partenza_reale >= (SELECT MAX(vr.orario_partenza_reale) FROM volo_reale) 
ORDER BY v.aeroporto_partenza, v.numero_volo, v.orario_partenza_previsto;

/* 5.
Con riferimento alla base di dati della domanda SQL VOLI 3, scrivere l'espressione dell'algebra relazionale per ottenere aeroporto di partenza, aeroporto di arrivo, numero di volo orario di partenza reale dei voli partiti il '2023-07-04' 
*/

π volo.aeroporto_partenza, volo.aeroporto_arrivo, volo.numero_volo, volo_reale.orario_partenza_reale (

   σ 

      (volor_reale.orario_partenza_reale = '2023-07-04')

      (volo ⨝ (volo.numero_volo = volo_reale.numero_volo) volo_reale)

);

/* 6.
... Rispondere nella casella sottostante, su quattro righe e quattro colonne, come avreste fatto nel modulo qui sopra.
*/

0 M3 0 500

M3 M3 500 500

M1 M1 1000 1000

M1 M1 1000 1000

/* 7. 
Con riferimento ad una relazione 

   Calciatori(Codice, Nome, Altezza, Ruolo) 

scrivere le interrogazioni SQL che calcolano, per ciascun ruolo, l’altezza media dei calciatori di tale ruolo, nei due casi seguenti:
1. si usa il valore nullo per indicare che l’altezza non è nota
2. si usa il valore 0 per indicare che l’altezza non è nota.
Rispondere nel riquadro sottostante 
*/

SELECT ruolo, ROUND(AVG(altezza)) AS mediaAltezza

FROM Calciatori

WHERE altezza IS NOT NULL 

GROUP BY ruolo;



-- In alcuni standard SQL il "WHERE altezza IS NOT NULL " NON serve.





SELECT ruolo, ROUND(AVG(altezza)) AS mediaAltezza

FROM Calciatori

WHERE altezza <> 0

GROUP BY ruolo;




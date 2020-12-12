DELIMITER $$

-- OPERAZIONE 1: REGISTRAZIONE DI UN UTENTE
DROP PROCEDURE IF EXISTS RegistraUtente $$
CREATE PROCEDURE RegistraUtente(
									IN _password VARCHAR(24), 
                                    IN _indirizzo VARCHAR(100), 
                                    IN _cognome VARCHAR(20), 
                                    IN _nome VARCHAR(20), 
                                    IN _codfiscale VARCHAR(16),
                                    IN _numdocumento VARCHAR(20),
                                    IN _tipologia VARCHAR(50),
                                    IN _scadenza DATE,
                                    IN _enterilascio VARCHAR(50)                                    
								)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    DECLARE idutente INT DEFAULT 0;
    
    -- Verifico se l'utente già esiste
    SET esiste =	(
						SELECT COUNT(*)
						FROM 	Utente U
						WHERE	U.CodFiscale = _codfiscale
					);
    
    IF esiste = 1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente già esistente';
	ELSEIF esiste = 0 THEN
		INSERT INTO Utente(Password_, Ruolo, Indirizzo, Cognome, Nome, CodFiscale, MediaVoto,DataIscrizione) VALUES (SHA1(_password), 'fruitore', _indirizzo, _cognome, _nome, _codfiscale, 0,current_timestamp());
         
		SELECT	Id INTO idutente
        FROM 	Utente U
        WHERE	U.CodFiscale = _codfiscale;
         
		INSERT INTO Documento(NumDocumento, Id, Tipologia, Scadenza, EnteRilascio) VALUES (_numdocumento, idutente, _tipologia, _scadenza, _enterilascio);
    END IF;
 END $$


-- OPERAZIONE 2: ELIMINAZIONE DI UN UTENTE
CREATE PROCEDURE EliminazioneUtente(IN _id INT, IN _password VARCHAR(128))
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    DECLARE idutente INT DEFAULT 0;
    DECLARE controllo VARCHAR(128);
    
    -- Verifico se l'utente esiste
    SET esiste = (	SELECT 	COUNT(*)
					FROM 	Utente U
					WHERE	U.Id = _id	);
    
    SET controllo = (	SELECT 	Password_
						FROM 	Utente
                        WHERE 	Id = _id	);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF ( (esiste = 1) AND (controllo = SHA1(_password)) ) THEN
		DELETE FROM Utente WHERE Id = _id;
		DELETE FROM Documento WHERE Id = _id;
		DELETE FROM Auto WHERE Id = _id;
	END IF;
END $$



-- OPERAZIONE 3: VISUALIZZAZIONE CARATTERISTICHE AUTO
DROP PROCEDURE IF EXISTS CaratteristicheAuto $$
CREATE PROCEDURE CaratteristicheAuto(IN _targa VARCHAR(9))
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    -- Verifico se l'auto esiste
    SET esiste =(	SELECT 	COUNT(*)	
					FROM 	Auto A
					WHERE	A.Targa = _targa	);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Auto non esistente';
	ELSEIF esiste = 1 THEN
		SELECT a.targa, c.numPosti, c.velocitaMax, c.annoImmatricolazione, c.alimentazione, c.cilindrata, c.modello,c.casaProduttrice, cm.urbano AS consumoUrbano, cm.extraUrbano AS consumoExtraUrbano, cm.misto AS consumoMisto,o.peso, o.connettivita,o.tavolino,o.tettoInVetro,o.bagagliaio,o.valutazioneAuto,o.rumoreMedio
        FROM Auto a NATURAL JOIN Optional o NATURAL JOIN ConsumoMedio cm NATURAL JOIN Caratteristiche c
        WHERE a.Targa = _targa;
        
	END IF;
END $$



-- OPERAZIONE 4: REGISTRAZIONE NUOVA AUTO
DROP PROCEDURE IF EXISTS RegistrazioneAuto $$
CREATE PROCEDURE RegistrazioneAuto	(
										IN _targa VARCHAR(9),
										IN _id INT, 
										IN _NumPosti INT,
										IN _VelocitaMax DOUBLE,
										IN _AnnoImmatricolazione INT,
										IN _Alimentazione VARCHAR(29),
                                        IN _Cilindrata INT,
                                        IN _Modello VARCHAR(29), 
										IN _CasaProduttrice VARCHAR(29), 
										IN _KmPercorsi  DOUBLE,
                                        IN _QuantitaCarburante DOUBLE,
                                        IN _CostoUsura DOUBLE,
                                        IN _Peso DOUBLE,
                                        IN _Connettività BOOL,
                                        IN _Tavolino BOOL,
                                        IN _TettoInVetro BOOL,
                                        IN _Bagagliaio DOUBLE,
                                        IN _ValutazioneAuto DOUBLE,
                                        IN _RumoreMedio DOUBLE,
                                        IN _ConsumoMedioUrbano DOUBLE,
                                        IN _ConsumoMedioExtraurbano DOUBLE,
                                        IN _ConsumoMedioMisto DOUBLE
									)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    -- Verifico se l'auto già esiste
    SET esiste =	(
						SELECT 	COUNT(*)
						FROM 	Auto A
						WHERE	A.Targa = _targa
					);
    
    IF esiste = 1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Auto già esistente';
	ELSEIF esiste = 0 THEN
		INSERT INTO Auto(Targa, Id) VALUES (_targa, _id);
        INSERT INTO Caratteristiche(Targa, NumPosti, VelocitaMax, AnnoImmatricolazione, Alimentazione, Cilindrata, Modello, CasaProduttrice) VALUES (_targa, _NumPosti, _VelocitaMax, _AnnoImmatricolazione, _Alimentazione, _Cilindrata, _Modello, _CasaProduttrice);
        INSERT INTO StatoIniziale(Targa, KmPercorsi, QuantitaCarburante, CostoUsura) VALUES (_targa, _KmPercorsi, _QuantitaCarburante, _CostoUsura);
        INSERT INTO Optional(Targa, Peso, Connettivita, Tavolino, TettoInVetro, Bagagliaio, ValutazioneAuto, RumoreMedio) VALUES (_targa, _Peso, _Connettivita, _Tavolino, _TettoInVetro, _Bagagliaio, _ValutazioneAuto, _RumoreMedio);
        INSERT INTO ConsumoMedio(Targa,Urbano,Extraurbano,Misto) VALUES (_targa, _ConsumoMedioUrbano, _ConsumoMedioExtraurbano,_ConsumoMedioMisto);
	END IF;
END $$


-- OPERAZIONE 5: VISUALIZZAZIONE VALUTAZIONE UTENTE
DROP PROCEDURE IF EXISTS ValutazioneUtente $$
CREATE PROCEDURE ValutazioneUtente(IN _id INT)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    
    SET esiste = (	SELECT 	COUNT(*)
					FROM 	Utente U
					WHERE	U.Id = _id );
    
   	IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
		SELECT	U.MediaVoto, AVG(S.Persona) AS Persona, AVG(S.PiacereViaggio) AS PiacereDiViaggio, AVG(S.Serieta) AS Serieta, AVG(S.Comportamento) AS Comportamento
        FROM 	Utente U NATURAL JOIN StelleUtente S
        WHERE 	U.Id = _id;
    END IF;
END $$


-- OPERAZIONE 6: CALCOLO COSTO DI UN POOL
DROP PROCEDURE IF EXISTS CostoPool $$
CREATE PROCEDURE CostoPool(IN _codpool INT)
BEGIN
	
    -- Dichiarazione delle variabili
    DECLARE esiste INT DEFAULT 0;
    DECLARE numKm DOUBLE DEFAULT 0;
    DECLARE costocarbutante DOUBLE DEFAULT 0;
    DECLARE usura DOUBLE DEFAULT 0;
    DECLARE urbano DOUBLE DEFAULT 0;
    DECLARE extraurbano DOUBLE DEFAULT 0;
    DECLARE misto DOUBLE DEFAULT 0;
    DECLARE stradapercorsa DOUBLE DEFAULT 0;
    DECLARE kmperstradaurbana DOUBLE DEFAULT 0;
    DECLARE kmperstradaextra DOUBLE DEFAULT 0;
    DECLARE kmperstradamista DOUBLE DEFAULT 0;
    DECLARE tipostrada VARCHAR(30) DEFAULT ' '; 
    DECLARE finito INT DEFAULT 0;
    DECLARE tot VARCHAR(4) DEFAULT 0; 	#per arrotondare 
    DECLARE kmfinest DOUBLE DEFAULT 0;
    DECLARE kminiziost DOUBLE DEFAULT 0;
    DECLARE _codstrada INT DEFAULT 0;
    
    
    -- Dichiarazione dei cursuori
    DECLARE InfoStrada CURSOR FOR
		SELECT	kmInizioStrada, kmFineStrada, CodStrada
		FROM	StradeTragittoPool
        WHERE	CodPool = _codpool;

	
    -- Dichiarazione Handler
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1; 
        
    -- Verifico se l'utente già esiste
    SET esiste =	(
						SELECT COUNT(*)
						FROM 	Pool P
						WHERE	P.CodPool = _codpool
					);
                    
    
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Pool non esistente';
	ELSEIF esiste = 1 THEN
		BEGIN
			SELECT 	TP.KmPercorsi INTO numKm
            FROM	TragittoPool TP
            WHERE	TP.CodPool = _codpool;
            
            SELECT 	S.CostoCarburante INTO costocarbutante
            FROM	SommaCostiAttualePool S
            WHERE	S.CodPool = _codpool;
            
			SELECT 	S.CostoUsura INTO usura
            FROM	SommaCostiAttualePool S
            WHERE	S.CodPool = _codpool;
            
            SELECT 	S.ConsumoUrbano INTO urbano
            FROM	SommaCostiAttualePool S
            WHERE	S.CodPool = _codpool;
            
            SELECT 	S.ConsumoExtraUrbano INTO extraurbano
            FROM	SommaCostiAttualePool S
            WHERE	S.CodPool = _codpool;
            
            SELECT 	S.ConsumoMisto INTO misto
            FROM	SommaCostiAttualePool S
            WHERE	S.CodPool = _codpool;
			
            OPEN InfoStrada;
			
            -- Ciclo
preleva : 	LOOP
				IF finito = 1 THEN
					LEAVE preleva;
				END IF;
                
                FETCH InfoStrada INTO kminiziost, kmfinest, _codstrada;
		
                SET stradapercorsa = kmfinest - kminiziost;
                
                SELECT 	ClassificazioneTecnica INTO tipostrada
                FROM	Strada
                WHERE	CodStrada = _codstrada;
                
                CASE
					WHEN tipostrada = 'Urbana' THEN
						SET kmperstradaurbana = kmperstradaurbana + stradapercorsa;
					WHEN tipostrada = 'ExtraUrbana' OR tipostrada = 'Autostrada' THEN
						SET kmperstradaextra = kmperstradaextra + stradapercorsa;
					WHEN tipostrada = 'Misto' THEN
						SET kmperstradamista = kmperstradamista + stradapercorsa;                        
                END CASE;
            END LOOP preleva;
            
            CLOSE InfoStrada;
			
            
            UPDATE	SommaCostiAttualePool
			SET		CostoOperativo = numKm*usura
			WHERE	CodPool = _codpool;
            
            UPDATE	SommaCostiAttualePool
			SET		ConsumoCarburante = (kmperstradaurbana/urbano) + (kmperstradaextra/extraurbano) + (kmperstradamista/misto)
			WHERE	CodPool = _codpool;
            
            
            SET tot = (kmperstradaurbana/urbano)*costocarbutante + (kmperstradaextra/extraurbano)*costocarbutante + (kmperstradamista/misto)*costocarbutante + numKm*usura;
			SELECT tot AS CostoPool;
		END;
	END IF;
END $$


-- OPERAZIONE 6 bis: CALCOLO COSTO DI UNO SHARING
DROP PROCEDURE IF EXISTS CostoSharing $$
CREATE PROCEDURE CostoSharing(IN _codsharing INT)
BEGIN
	
    -- Dichiarazione delle variabili
    DECLARE esiste INT DEFAULT 0;
    DECLARE numKm DOUBLE DEFAULT 0;
    DECLARE costocarburante DOUBLE DEFAULT 0;
    DECLARE usura DOUBLE DEFAULT 0;
    DECLARE urbano DOUBLE DEFAULT 0;
    DECLARE extraurbano DOUBLE DEFAULT 0;
    DECLARE misto DOUBLE DEFAULT 0;
    DECLARE stradapercorsa DOUBLE DEFAULT 0;
    DECLARE kmperstradaurbana DOUBLE DEFAULT 0;
    DECLARE kmperstradaextra DOUBLE DEFAULT 0;
    DECLARE kmperstradamista DOUBLE DEFAULT 0;
    DECLARE tipostrada VARCHAR(30) DEFAULT ' '; 
    DECLARE finito INT DEFAULT 0;
    DECLARE kmfinest DOUBLE DEFAULT 0;
    DECLARE kminiziost DOUBLE DEFAULT 0;
    DECLARE _codstrada INT DEFAULT 0;
    
    
    -- Dichiarazione cursore
    DECLARE InfoStrada CURSOR FOR
		SELECT	kmInizioStrada, kmFineStrada, CodStrada
		FROM	StradeTragittoSharing
        WHERE	CodSharing = _codsharing;
	
    -- Dichiarazione Handler
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1; 
        
    -- Verifico se l'utente già esiste
    SET esiste =	(
						SELECT COUNT(*)
						FROM 	RideSharing RS
						WHERE	RS.CodSharing = _codsharing
					);
    
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Sharing non esistente';
	ELSEIF esiste = 1 THEN
		BEGIN
			SELECT 	TP.KmPercorsi INTO numKm
            FROM	TragittoSharing TP
            WHERE	TP.CodSharing = _codsharing;
            
            SELECT 	S.CostoCarburante INTO costocarburante
            FROM	RideSharing S
            WHERE	S.CodSharing = _codsharing;
            
			SELECT 	S.CostoUsura INTO usura
            FROM	StatoIniziale S INNER JOIN RideSharing RS ON S.Targa = RS.Targa
            WHERE	RS.CodSharing = _codsharing;
            
            SELECT 	C.Urbano INTO urbano
            FROM	ConsumoMedio C INNER JOIN RideSharing RS ON C.Targa = RS.Targa
            WHERE	RS.CodSharing = _codsharing;
            
            SELECT 	C.ExtraUrbano INTO extraurbano
            FROM	ConsumoMedio C INNER JOIN RideSharing RS ON C.Targa = RS.Targa
            WHERE	RS.CodSharing = _codsharing;
            
            SELECT 	C.Misto INTO misto
            FROM	ConsumoMedio C INNER JOIN RideSharing RS ON C.Targa = RS.Targa
            WHERE	RS.CodSharing = _codsharing;
			
            OPEN InfoStrada;
			
            -- Ciclo
preleva : 	LOOP
				IF finito = 1 THEN
					LEAVE preleva;
				END IF;
                
                FETCH InfoStrada INTO kminiziost, kmfinest, _codstrada;
                
                SET stradapercorsa = kmfinest - kminiziost;
                
                SELECT 	ClassificazioneTecnica INTO tipostrada
                FROM	Strada
                WHERE	CodStrada = _codstrada;
                
                CASE
					WHEN tipostrada = 'Urbana' THEN
						SET kmperstradaurbana = kmperstradaurbana + stradapercorsa;
					WHEN tipostrada = 'ExtraUrbana' OR tipostrada = 'Autostrada' THEN
						SET kmperstradaextra = kmperstradaextra + stradapercorsa;
					WHEN tipostrada = 'Misto' THEN
						SET kmperstradamista = kmperstradamista + stradapercorsa;                        
                END CASE;
            END LOOP preleva;
            
            CLOSE InfoStrada;
            
            UPDATE	RideSharing
			SET		Prezzo = numKm*usura + (kmperstradaurbana/urbano) + (kmperstradaextra/extraurbano) + (kmperstradamista/misto)
			WHERE	CodSharing = _codSharing;
            
            SELECT Prezzo AS PrezzoSharing
            FROM RideSharing
            WHERE CodSharing = _codsharing;
            
		END;
	END IF;
END $$

-- OPERAZIONE 7: VISUALIZZAZIONE AFFIDABILITA' UTENTE
DROP PROCEDURE IF EXISTS AffidabilitaUtente $$
CREATE PROCEDURE AffidabilitaUtente(IN _id INT)
BEGIN
	DECLARE esiste INT DEFAULT 0;
    DECLARE mediavoto DOUBLE DEFAULT 0;
	DECLARE X INT DEFAULT 0;
	DECLARE Y DOUBLE DEFAULT 0;
	DECLARE percent DOUBLE DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    DECLARE Affidabilita DOUBLE DEFAULT 0;


    DECLARE PercentCursorNoleggio CURSOR FOR
		SELECT	PercentualeDiResponsabilita
        FROM 	SinistroNoleggio 
        WHERE 	IdGuidatore = _id
				AND
				YEAR(CURRENT_DATE) -  4  < YEAR(Orario);
	
    DECLARE PercentCursorSharing CURSOR FOR
		SELECT	SS.PercentualeDiResponsabilita
        FROM 	SinistroSharing SS INNER JOIN Auto A ON SS.TargaVeicoloProponente = A.Targa
        WHERE 	A.Id = _id
				AND
				YEAR(CURRENT_DATE) -  4  < YEAR(SS.Orario);
	
    DECLARE PercentCursorPool CURSOR FOR
		SELECT	SP.PercentualeDiResponsabilita
        FROM 	SinistroPool SP INNER JOIN Auto A ON SP.TargaVeicoloProponente = A.Targa
        WHERE 	A.Id = _id
				AND
				YEAR(CURRENT_DATE) - 4 < YEAR(SP.Orario);
    
    -- Dichiarazione Handler
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;  
    
    -- Verifico se l'utente già esiste
    SET esiste =	(
						SELECT COUNT(*)
						FROM 	Utente U
						WHERE	U.Id = _id
					);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
		
        SELECT 	U.MediaVoto INTO mediavoto
		FROM	Utente U
		WHERE	U.Id = _id;
        
        CASE 
			WHEN (mediavoto <= 5.0) AND (mediavoto >= 4.8) THEN
				SET X = 0;
			WHEN (mediavoto <= 4.7) AND (mediavoto >= 4.5) THEN
				SET X = 10;
			WHEN (mediavoto <= 4.4) AND (mediavoto >= 4.1) THEN
				SET X = 15;
			WHEN (mediavoto <= 4.0) AND (mediavoto >= 3.7) THEN
				SET X = 20;
			WHEN (mediavoto <= 3.6) AND (mediavoto >= 3.1) THEN
				SET X = 35;
			WHEN (mediavoto <= 3.0) AND (mediavoto >= 2.8) THEN
				SET X = 40;
			WHEN (mediavoto <= 2.4) AND (mediavoto >= 2.2) THEN
				SET X = 50;
			WHEN (mediavoto <= 1.9) AND (mediavoto >= 1.0) THEN
				SET X = 60;
			WHEN (mediavoto <= 0.9) THEN
				SET X = 80;
			
			ELSE
				BEGIN
				END;
		END CASE;    
        
       
		OPEN PercentCursorNoleggio;
        
		prelevanoleggio: LOOP
        
        FETCH PercentCursorNoleggio INTO percent;
			IF finito = 1 THEN
				SET finito = 0;
				LEAVE prelevanoleggio;
			END IF;
			
			
			CASE 
				WHEN (percent <= 100) AND (percent >= 91) THEN
                    SET Y = Y + percent*(10/20);
				WHEN (percent <= 90) AND (percent >= 71) THEN
					SET Y = Y + percent*(6/20);
				WHEN (percent <= 70) AND (percent >= 51) THEN
					SET Y = Y + percent*(5/20);
				WHEN (percent <= 50) AND (percent >= 31) THEN
					SET Y = Y + percent*(4/20);
				WHEN (percent <= 30) AND (percent >= 21) THEN
					SET Y = Y + percent*(3/20);
				WHEN (percent <= 20) AND (percent >= 11) THEN
					SET Y = Y + percent*(2/20);
				WHEN (percent <= 10) AND (percent >= 0) THEN
					SET Y = Y + percent*(1/20);
			
				ELSE
					BEGIN
                    END;
            END CASE; 
            
		END LOOP prelevanoleggio;
        
        CLOSE PercentCursorNoleggio;
     
		OPEN PercentCursorSharing;       
        
        prelevasharing: LOOP
        FETCH PercentCursorSharing INTO percent;
			IF finito = 1 THEN
				SET finito = 0;
				LEAVE prelevasharing;
			END IF;
			
			CASE 
				WHEN (percent <= 100) AND (percent >= 91) THEN
					SET Y = Y + percent*(10/20);
				WHEN (percent <= 90) AND (percent >= 71) THEN
					SET Y = Y + percent*(6/20);
				WHEN (percent <= 70) AND (percent >= 51) THEN
					SET Y = Y + percent*(5/20);
				WHEN (percent <= 50) AND (percent >= 31) THEN
					SET Y = Y + percent*(4/20);
				WHEN (percent <= 30) AND (percent >= 21) THEN
					SET Y = Y + percent*(3/20);
				WHEN (percent <= 20) AND (percent >= 11) THEN
					SET Y = Y + percent*(2/20);
				WHEN (percent <= 10) AND (percent >= 0) THEN
					SET Y = Y + percent*(1/20);
                ELSE
					BEGIN
                    END;
			END CASE; 
		END LOOP prelevasharing;                    
		
        CLOSE PercentCursorSharing;

         OPEN PercentCursorPool;
         
        prelevapool: LOOP
        FETCH PercentCursorPool INTO percent;
			IF finito = 1 THEN
				LEAVE prelevapool;
			END IF;
			
			CASE 
				WHEN (percent <= 100) AND (percent >= 91) THEN
					SET Y = Y + percent*(10/20);
				WHEN (percent <= 90) AND (percent >= 71) THEN
					SET Y = Y + percent*(6/20);
				WHEN (percent <= 70) AND (percent >= 51) THEN
					SET Y = Y + percent*(5/20);
				WHEN (percent <= 50) AND (percent >= 31) THEN
					SET Y = Y + percent*(4/20);
				WHEN (percent <= 30) AND (percent >= 21) THEN
					SET Y = Y + percent*(3/20);
				WHEN (percent <= 20) AND (percent >= 11) THEN
					SET Y = Y + percent*(2/20);
				WHEN (percent <= 10) AND (percent >= 0) THEN
					SET Y = Y + percent*(1/20);
				
                ELSE
					BEGIN
                    END;
			END CASE; 
		END LOOP prelevapool; 
        
        CLOSE PercentCursorPool;
        
        
        SET Affidabilita = (40 - X) + (60 - Y);
        
        CASE
			WHEN (Affidabilita <= 40) THEN 
				UPDATE Utente U
				SET U.Affidabilita = 'BASSA'
                WHERE U.id = _id;
			WHEN (Affidabilita BETWEEN 40 AND 70) THEN 
				UPDATE Utente U
				SET U.Affidabilita = 'MEDIA'
                WHERE U.id = _id;
			WHEN (Affidabilita >= 70) THEN 
				UPDATE Utente U
				SET U.Affidabilita = 'ALTA'
                WHERE U.id = _id;
			END CASE;
   SELECT Affidabilita;
   
    END IF;
END $$

-- OPERAZIONE 8: Calcolo numero posti rimanenti pool
DROP PROCEDURE IF EXISTS NumeroPostiRimanentiPool $$
CREATE PROCEDURE NumeroPostiRimanentiPool(IN _codPool INT)
BEGIN 
	DECLARE postirimanenti INT DEFAULT 0;
	DECLARE postioccupati INT DEFAULT 0;
    DECLARE postidisponibili INT DEFAULT 0;
    
    SET postioccupati = (SELECT COUNT(*)
						 FROM AdesioniPool
                         WHERE CodPool = _codPool);
	
    SET postidisponibili = (SELECT NumPosti
							FROM Pool 
							WHERE CodPool = _codPool);
                            
	
    SELECT postioccupati, postidisponibili;
END $$


-- OPERAZIONE 8bis: Calcolo numero posti rimanenti su un ride sharing
DROP PROCEDURE IF EXISTS NumeroPostiRimanentiSharing $$
CREATE PROCEDURE NumeroPostiRimanentiSharing(IN _codSharing INT)
BEGIN 
	DECLARE postirimanenti INT DEFAULT 0;
	DECLARE postioccupati INT DEFAULT 0;
    DECLARE postidisponibili INT DEFAULT 0;
    
    SET postioccupati = (SELECT COUNT(CodSharing)
						 FROM AdesioniRideSharing
                         WHERE CodSharing = _codSharing);
	
    SET postidisponibili = (SELECT NumPosti
							FROM RideSharing 
							WHERE CodSharing = _codSharing);
                            
	SET postirimanenti = postidisponibili - postioccupati;
    
    SELECT postioccupati, postidisponibili, postirimanenti;
END $$


-- OPERAZIONE 9: CALCOLO NUMERO DI POOL E RIDE SHARING FATTI DA UN SINGOLO UTENTE
DROP PROCEDURE IF EXISTS NumeroServiziErogati $$
CREATE PROCEDURE NumeroServiziErogati(IN _id INT)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
	DECLARE n INT DEFAULT 0;
 	
    -- Verifico se l'utente già esiste
    SET esiste =	(
						SELECT 	COUNT(*)
						FROM 	Utente U
						WHERE	U.Id = _id
					);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
	SET N =	(
				SELECT	COUNT(*)
				FROM 	RideSharing RS INNER JOIN Auto A ON RS.Targa = A.Targa
                WHERE	A.Id = _id
			)
            +
            (
				SELECT	COUNT(*)
				FROM 	Pool P INNER JOIN Auto A ON P.Targa = A.Targa
                WHERE A.Id = _id
            );
            
            SELECT n AS NumeroServiziErogati;
    END IF;
END $$

DELIMITER ;
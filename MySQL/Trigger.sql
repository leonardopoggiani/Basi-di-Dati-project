DELIMITER $$

CREATE TRIGGER controllo_incrocio
BEFORE INSERT ON Incrocio FOR EACH ROW
BEGIN
	DECLARE strada1 INT DEFAULT 0;
    DECLARE strada2 INT DEFAULT 0;
    DECLARE km1 INT DEFAULT 0;
    DECLARE km2 INT DEFAULT 0;
    
    SET strada1 = (	SELECT 	COUNT(CodStrada)
					FROM 	Strada
                    WHERE 	CodStrada = NEW.CodStrada1);
                    
	SET strada2 = (	SELECT 	COUNT(CodStrada)
					FROM 	Strada
                    WHERE 	CodStrada = NEW.CodStrada2);
	
    IF (strada1 = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
    END IF;
    
    IF (strada2 = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
    END IF;
    
    SET km1 = (	SELECT 	Lunghezza
				FROM 	Strada
                WHERE 	CodStrada = NEW.CodStrada1);
	
	SET km2 = (	SELECT 	Lunghezza
				FROM 	Strada
                WHERE 	CodStrada = NEW.CodStrada2);
                
		IF(km1 < NEW.kmStrada1)	THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Inserire chilometro valido';
		END IF;
        
        IF(km2 < NEW.kmStrada2)	THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Inserire chilometro valido';
		END IF;
END $$



CREATE TRIGGER aggiorna_media_voto
AFTER INSERT ON StelleUtente FOR EACH ROW
BEGIN
	SET @media_Persona = (SELECT AVG(Persona)
									 FROM StelleUtente
									 WHERE Id = new.Id
                                     );
	
	SET @media_PiacereViaggio = (SELECT AVG(PiacereViaggio)
									 FROM StelleUtente
									 WHERE Id = new.Id
                                     );		
                                     
	SET @media_Serieta =  (SELECT AVG(Serieta)
									 FROM StelleUtente
									 WHERE Id = new.Id
                                     );
	SET @media_Comportamento =  (SELECT AVG(Comportamento)
									 FROM StelleUtente
									 WHERE Id = new.Id
                                     );
	
    SET @media = (@media_Persona + @media_PiacereViaggio + @media_Serieta + @media_Comportamento)/4;
    
    IF((@media < 0) OR (@media > 5)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
    END IF;
    
    UPDATE Utente
    SET MediaVoto = @media
    WHERE Id = NEW.Id;

END $$


-- Errore di default:
	/* SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'qualcosa';
	*/
    
CREATE TRIGGER controllo_stelle
BEFORE INSERT ON StelleUtente FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$

CREATE TRIGGER controllo_stelle_proponente_noleggio
BEFORE INSERT ON StelleProponenteNoleggio FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$


CREATE TRIGGER controllo_stelle_fruitore_noleggio
BEFORE INSERT ON StelleFruitoreNoleggio FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;
END $$



CREATE TRIGGER controllo_stelle_proponente_pool
BEFORE INSERT ON StelleProponentePool FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$

CREATE TRIGGER controllo_stelle_fruitore_pool
BEFORE INSERT ON StelleFruitorePool FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$

CREATE TRIGGER controllo_stelle_proponente_ride_sharing
BEFORE INSERT ON StelleProponenteRideSharing FOR EACH ROW
BEGIN
	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$

CREATE TRIGGER controllo_stelle_fruitore_ride_sharing
BEFORE INSERT ON StelleFruitoreRideSharing FOR EACH ROW
BEGIN

	IF(NEW.Persona > 5 OR NEW.Persona < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Comportamento > 5 OR NEW.Comportamento < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.PiacereViaggio > 5 OR NEW.PiacereViaggio < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
	
    ELSEIF(NEW.Serieta > 5 OR NEW.Serieta < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
        
	END IF;

END $$

CREATE TRIGGER controlla_data_scadenza_documenti
BEFORE INSERT ON Documento FOR EACH ROW

BEGIN
	IF(NEW.Scadenza < current_date()) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Documento scaduto';
	END IF;
    
    UPDATE Utente
    SET Stato = 'ATTIVO'
    WHERE Id = NEW.Id;
    
END $$ 
		
CREATE TRIGGER controlla_posizione_partenza_noleggio
BEFORE INSERT ON PosizionePartenzaNoleggio FOR EACH ROW

BEGIN
	SET @km = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada );
                
	IF(NEW.numChilometro > @km) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
	END IF;
    
END $$

CREATE TRIGGER controlla_posizione_arrivo_noleggio
BEFORE INSERT ON PosizioneArrivoNoleggio FOR EACH ROW

BEGIN
	SET @km = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada );
                
	IF(NEW.numChilometro > @km) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
	END IF;
    
END $$

CREATE TRIGGER verifica_pedaggio
BEFORE INSERT ON Pedaggio FOR EACH ROW

BEGIN
	IF(NEW.Importo < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Immettere importo valido';
	END IF;
        
	SET @strada = NEW.CodStrada;
    
    SET @tipo_strada_da_controllare = (SELECT Tipologia
										FROM Strada
                                        WHERE CodStrada = @strada);
	
    IF(@tipo_strada_da_controllare <> 'Autostrada') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'La strada selezionata non è una autostrada';
	END IF;
        
	SET @km = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = @strada);
	IF(NEW.kmStrada1 < 0 OR NEW.kmStrada2 < 0 OR NEW.kmStrada1 > @km OR NEW.kmStrada2 > @km) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Immettere un chilometro corretto';
	END IF;
END $$ 



CREATE TRIGGER controlla_prenotazione_di_noleggio
BEFORE INSERT ON PrenotazioneDiNoleggio FOR EACH ROW

BEGIN
	IF(NEW.DataInizio < current_date() OR NEW.DataFine < current_date()) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Immettere una data valida';
	END IF;

	SET @fruitore = (SELECT Id
					FROM Utente
					WHERE Id = NEW.IdFruitore);
                    
	IF(@fruitore = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Immettere un utente esistente';
	END IF;
	
    SET @ruolo = (SELECT Ruolo 
				FROM Utente U
					INNER JOIN Auto A ON U.Id = A.Id
				WHERE A.Targa = NEW.Targa);
                
	IF(@ruolo <> 'Proponente') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Id associato ad un utente non proponente';
	END IF;
    
    IF(NEW.Prezzo < 0) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire prezzo valido';
	END IF;
    
     SET @auto = (SELECT Targa
					FROM Utente U 
						JOIN Auto A ON U.Id = A.Id
					WHERE NEW.Targa = Targa);
                    
	IF(@auto = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nessuna auto registrata per questo utente';
	END IF;
    
    
END $$

CREATE TRIGGER aggiungi_consumo_iniziale
BEFORE INSERT ON PrenotazioneDiNoleggio FOR EACH ROW
BEGIN
	SET @carburante = (SELECT QuantitaCarburante
						FROM StatoIniziale
                        WHERE Targa = NEW.Targa);
	
    SET NEW.QuantitaCarburanteFinale = @carburante;
    
END $$


CREATE TRIGGER aggiorna_ruolo
AFTER INSERT ON Auto FOR EACH ROW

BEGIN
	SET @ruolo = (SELECT Ruolo
				  FROM Utente
                  WHERE Id = NEW.Id);
	
    IF(@ruolo = 'Fruitore') THEN
		UPDATE Utente
        SET Ruolo = 'Proponente'
        WHERE Id = NEW.Id;
	END IF;
END $$


CREATE TRIGGER verifica_immissione
BEFORE INSERT ON CorsieDiImmissione
FOR EACH ROW
BEGIN
	IF NEW.CodStrada1 = NEW.CodStrada2 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Le trade non possono essere uguali!';
	END IF;
END $$




CREATE TRIGGER verifica_limite_di_velocita
BEFORE INSERT ON LimitiDiVelocita FOR EACH ROW
BEGIN
	IF (NEW.kmFine <= NEW.kmInizio) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Chilometri non validi!';
	END IF;
    
    IF  ((NEW.ValoreLimite < 10) OR (NEW.ValoreLimite > 130) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Valore Limite di velocità non valido';
	END IF;
    
    SET @chilometri = (SELECT Lunghezza
						FROM Strada
						WHERE CodStrada = NEW.CodStrada);
	
    IF( (NEW.kmFine > @chilometri) OR (NEW.kmInizio > @chilometri) OR (NEW.kmFine < 0) OR (NEW.kmInizio <0) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Immettere un chilometro valido';
	END IF;
    
END $$


CREATE TRIGGER controlla_posizione_arrivo_sharing
BEFORE INSERT ON PosizioneArrivoSharing FOR EACH ROW

BEGIN
	SET @km = (SELECT Lunghezza
				FROM Strada S
					INNER JOIN StradeTragittoSharing STS ON S.CodStrada = STS.CodStrada
                WHERE S.CodStrada = NEW.CodStrada
					AND STS.CodSharing = NEW.CodSharing);
                
	IF(NEW.numChilometro > @km) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
	END IF;
    
END $$
 
 
CREATE TRIGGER controlla_posizione_partenza_sharing
BEFORE INSERT ON PosizionePartenzaSharing FOR EACH ROW

BEGIN
	SET @km = (SELECT Lunghezza
				FROM Strada S
					INNER JOIN StradeTragittoSharing STS ON S.CodStrada = STS.CodStrada
                WHERE S.CodStrada = NEW.CodStrada 
					AND STS.CodSharing = NEW.CodSharing);
                
	IF(NEW.numChilometro > @km) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
	END IF;
    
END $$


CREATE TRIGGER archivia_prenotazioni_di_noleggio
AFTER UPDATE ON PrenotazioneDiNoleggio FOR EACH ROW

BEGIN
	IF(NEW.Stato = 'CHIUSO') THEN
		INSERT ArchivioPrenotazioniVecchie
		SET CodNoleggio = NEW.CodNoleggio, DataInizio = NEW.DataInizio, DataFine = NEW.DataFine, IdFruitore 		= NEW.IdFruitore, Targa = NEW.Targa;
		DELETE FROM PrenotazioneDiNoleggio
		WHERE CodNoleggio = NEW.CodNoleggio;
    END IF;
    
    IF(NEW.Stato = 'RIFIUTATO') THEN
		INSERT ArchivioPrenotazioniRifiutate
		SET CodNoleggio = NEW.CodNoleggio, IdFruitore = NEW.IdFruitore, Targa = NEW.Targa;
		DELETE FROM PrenotazioneDiNoleggio
		WHERE CodNoleggio = NEW.CodNoleggio;
    END IF;
    
    
END $$
	

CREATE TRIGGER controllo_sinistro_noleggio		
BEFORE INSERT ON SinistroNoleggio FOR EACH ROW

BEGIN
	IF(NEW.Orario > current_timestamp()) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire orario valido';
	END IF;
    
    SET @strada = (SELECT CodStrada
					FROM Strada
                    WHERE CodStrada = NEW.CodStrada);
                    
	 SET @chilometro = (SELECT Lunghezza
						FROM Strada
						WHERE CodStrada = NEW.CodStrada);
                    
	IF( (@strada = NULL) OR (NEW.kmStrada < 0) OR (NEW.kmStrada > @chilometro) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
	END IF;
    
    
    IF( (NEW.PercentualeDiResponsabilita < 0) OR (NEW.PercentualeDiResponsabilita > 100) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire percentuale valida';
	END IF;
    
    SET @modello = (SELECT Modello
					FROM Caratteristiche
                    WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.Modello = @modello;
    
    SET @casaautomobilistica = (SELECT CasaProduttrice
								FROM Caratteristiche
                                WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.CasaAutomobilistica = @casaautomobilistica;
    
END $$


CREATE TRIGGER controllo_generalita_sinistro_noleggio
BEFORE INSERT ON GeneralitaSinistroNoleggio FOR EACH ROW

BEGIN
	SET @numDocumento = (SELECT NumDocumento
						 FROM Documento D
							JOIN Utente U ON D.Id = U.Id
						 WHERE NEW.NumDocumento = NumDocumento);
                         
	IF((@numDocumento = NULL) OR (@numDocumento <> NEW.NumDocumento) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Documento inserito non valido';
	END IF;
    
    SET @codFiscale = (SELECT CodFiscale
						FROM Utente U
							JOIN Documento D ON U.Id = D.Id
						WHERE NumDocumento = NEW.NumDocumento);
                        
	IF(@codFiscale = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
END$$


CREATE TRIGGER aggiungi_documento_sinistro_noleggio		#inserite le generalità di un utente inserisce 
													    # il suo documento
AFTER INSERT ON GeneralitaSinistroNoleggio FOR EACH ROW

BEGIN
	INSERT DocumentoDiIdentitaSinistroNoleggio
    SELECT NumDocumento, Tipologia, Scadenza, EnteRilascio
    FROM Documento
	WHERE NumDocumento = NEW.NumDocumento;
    
END $$
 
CREATE TRIGGER controllo_pool
BEFORE INSERT ON Pool FOR EACH ROW

BEGIN
	DECLARE postiauto INT DEFAULT 0;
	
	IF(NEW.GiornoArrivo < NEW.GiornoPartenza) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire un orario valido';
	END IF;
    
    SET @proponente = (SELECT U.Id
						FROM Utente U
							INNER JOIN Auto A ON U.Id = A.Id
						WHERE NEW.Targa = A.Targa);
                        
	IF(@proponente = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente non trovato';
	END IF;
    
    SET @ruolo = (SELECT Ruolo
					FROM Utente
					WHERE Id = @proponente);
	
    
    IF(@ruolo <> 'Proponente') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non registrato come proponente';
	END IF;
    
    SET @auto = (SELECT Targa
					FROM Utente U 
						JOIN Auto A ON U.Id = A.Id
					WHERE NEW.Targa = Targa);
                    
	IF(@auto = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nessuna auto registrata per questo utente';
	END IF;
    
    SET postiauto = (SELECT NumPosti
					 FROM Caratteristiche
                     WHERE NEW.Targa = Targa);
    
    IF((NEW.NumPosti < 0) OR (NEW.NumPosti > postiauto)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire un numero di posti valido';
	END IF;
    
    SET NEW.numPosti = postiauto - 1;
		
END $$

CREATE TRIGGER controllo_posto_disponibile_pool
BEFORE UPDATE ON Pool FOR EACH ROW
BEGIN
	IF(NEW.numPosti < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Il pool è pieno';
	END IF;
    
END $$ 

CREATE TRIGGER controllo_posto_disponibile_sharing
BEFORE INSERT ON AdesioniRideSharing FOR EACH ROW
BEGIN
	DECLARE postidisponibili INT DEFAULT 0;
    DECLARE postioccupati INT DEFAULT 0;
    DECLARE postirimanenti INT DEFAULT 0;
    
    SET postidisponibili = (SELECT NumPosti
							FROM RideSharing RS
                            WHERE RS.CodSharing = NEW.CodSharing);
                            
	SET postioccupati = (SELECT COUNT(*)
						 FROM AdesioniRideSharing ARS
                         WHERE NEW.CodSharing = ARS.CodSharing);
                         
	SET postirimanenti = postidisponibili - postioccupati;
	
    IF(postirimanenti - 1 < 0) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Lo sharing è pieno';
	END IF;

END$$ 


CREATE TRIGGER archivia_pool
AFTER UPDATE ON Pool FOR EACH ROW

BEGIN
	IF(NEW.Stato = 'CHIUSO') THEN
    
		INSERT ArchivioPoolVecchi
        SET CodPool = NEW.CodPool, GradoFlessibilita = NEW.GradoFlessibilita, GiornoArrivo = NEW.GiornoArrivo, GiornoPartenza = NEW.GiornoPartenza, Targa = NEW.Targa;
        
		DELETE FROM Pool
		WHERE CodPool = NEW.CodPool;
        
   END IF;
    
END $$


CREATE TRIGGER controlla_posizione_arrivo_pool
BEFORE INSERT ON PosizioneArrivoPool FOR EACH ROW

BEGIN

	SET @km = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada );
                
	IF(NEW.numChilometro > @km) THEN 
    
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
        
	END IF;
    
END $$


CREATE TRIGGER controlla_posizione_partenza_pool
BEFORE INSERT ON PosizionePartenzaPool FOR EACH ROW

BEGIN
	SET @km = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada );
                
	IF(NEW.numChilometro > @km) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'numChilometro non valido';
	END IF;
    
END $$

CREATE TRIGGER controllo_sinistro_pool
BEFORE INSERT ON SinistroPool FOR EACH ROW

BEGIN
	IF(NEW.Orario > current_timestamp()) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire orario valido';
	END IF;
    
    SET @strada = (SELECT CodStrada
					FROM Strada
                    WHERE CodStrada = NEW.CodStrada);
                    
	 SET @chilometro = (SELECT Lunghezza
						FROM Strada
						WHERE CodStrada = NEW.CodStrada);
                    
	IF( (@strada = NULL) OR (NEW.kmStrada < 0) OR (NEW.kmStrada > @chilometro) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
	END IF;
    
    
    IF( (NEW.PercentualeDiResponsabilita < 0) OR (NEW.PercentualeDiResponsabilita > 100) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire percentuale valida';
	END IF;
    
    SET @modello = (SELECT Modello
					FROM Caratteristiche
                    WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.Modello = @modello;
    
    SET @casaautomobilistica = (SELECT CasaProduttrice
								FROM Caratteristiche
                                WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.CasaAutomobilistica = @casaautomobilistica;
END $$


CREATE TRIGGER controllo_generalita_sinistro_pool
BEFORE INSERT ON GeneralitaSinistroPool FOR EACH ROW

BEGIN
	SET @numDocumento = (SELECT NumDocumento
						 FROM Documento D
							JOIN Utente U ON D.Id = U.Id
						 WHERE NEW.NumDocumento = NumDocumento);
                         
	IF((@numDocumento = NULL) OR (@numDocumento <> NEW.NumDocumento) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Documento inserito non valido';
	END IF;
    
    SET @codFiscale = (SELECT CodFiscale
						FROM Utente U
							JOIN Documento D ON U.Id = D.Id
						WHERE NumDocumento = NEW.NumDocumento);
                        
	IF(@codFiscale = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
END$$


CREATE TRIGGER aggiungi_documento_sinistro_pool		#inserite le generalità di un utente inserisce 
													    # il suo documento
AFTER INSERT ON GeneralitaSinistroPool FOR EACH ROW

BEGIN
	INSERT DocumentoDiIdentitaSinistroPool
    SELECT NumDocumento, Tipologia, Scadenza, EnteRilascio
    FROM Documento
	WHERE NumDocumento = NEW.NumDocumento;
    
END $$

CREATE TRIGGER controlla_somma_costi
BEFORE INSERT ON SommaCostiAttualePool FOR EACH ROW

BEGIN
	IF(NEW.ConsumoCarburante < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire importo valido';
	END IF;
    
    IF(NEW.CostoCarburante < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
    
    IF(NEW.CostoOperativo < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
    IF(NEW.CostoUsura < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
    IF(NEW.ConsumoUrbano < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
    IF(NEW.ConsumoExtraurbano < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
    IF(NEW.ConsumoMisto < 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
END $$
 
CREATE TRIGGER aggiungi_somma_costi_pool
AFTER INSERT ON Pool FOR EACH ROW

BEGIN

	SET @auto = (SELECT Targa
				 FROM Auto 
                 WHERE Targa = NEW.Targa);
     
	SET @urbano = (SELECT Urbano
					FROM ConsumoMedio
                    WHERE Targa = @auto);
	
	SET @extraurbano = (SELECT ExtraUrbano
					FROM ConsumoMedio
                    WHERE Targa = @auto);
                    
	SET @misto = (SELECT Misto
					FROM ConsumoMedio
                    WHERE Targa = @auto);
                    
    SET @usura = (SELECT CostoUsura
					FROM StatoIniziale
                    WHERE Targa = @auto);
                    
     SET @alimentazione = (SELECT Alimentazione
							FROM Caratteristiche
							WHERE Targa = @auto);               
	CASE 
		WHEN @alimentazione = 'Gasolio' THEN
			SET @costoCarburante = 1.5;
		WHEN @alimentazione = 'Benzina' THEN
			SET @costoCarburante = 1.6;
		WHEN @alimentazione = 'Gpl' THEN
			SET @costoCarburante = 0.7;
		WHEN @alimentazione = 'Metano' THEN
			SET @costoCarburante = 1;
		WHEN @alimentazione = 'Elettrica' THEN
			SET @costoCarburante = 0.01; -- 60 minuti di ricarica* 0.025 costo medio ricarica ENEL 
										-- 1.5€ per un autonomia media di 150 km.
		ELSE
			BEGIN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Inserire un tipo di alimentazione corretta';
            END;
            
	END CASE;
    
	INSERT SommaCostiAttualePool
    SET ConsumoUrbano = @urbano, ConsumoExtraUrbano = @extraurbano, ConsumoMisto = @misto, CodPool = NEW.CodPool, CostoUsura = @usura, CostoCarburante = @costoCarburante;
    
END $$

CREATE TRIGGER aggiungi_costo_carburante_sharing
BEFORE INSERT ON RideSharing FOR EACH ROW
BEGIN
	
    SET @alimentazione = (SELECT Alimentazione
							FROM Caratteristiche
							WHERE Targa = NEW.Targa);               
	CASE 
		WHEN @alimentazione = 'Gasolio' THEN
			SET NEW.costoCarburante = 1.5;
		WHEN @alimentazione = 'Benzina' THEN
			SET NEW.costoCarburante = 1.6;
		WHEN @alimentazione = 'Gpl' THEN
			SET NEW.costoCarburante = 0.7;
		WHEN @alimentazione = 'Metano' THEN
			SET NEW.costoCarburante = 1;
		WHEN @alimentazione = 'Elettrica' THEN
			SET NEW.costoCarburante = 0.01; -- 60 minuti di ricarica* 0.025 costo medio ricarica ENEL 
										-- 1.5€ per un autonomia media di 150 km.
		ELSE
			BEGIN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Inserire un tipo di alimentazione corretta';
            END;
            
	END CASE;
    
END $$


CREATE TRIGGER aggiungi_somma_costi_vecchia_pool
AFTER INSERT ON ArchivioPoolVecchi FOR EACH ROW
BEGIN
	INSERT SommaCostiVecchiaPool
    SELECT * 
    WHERE CodPool = NEW.CodPool;
END $$

CREATE TRIGGER aggiorna_posti_disponibili_pool
AFTER INSERT ON AdesioniPool FOR EACH ROW
BEGIN
	UPDATE Pool
    SET NumPosti = NumPosti - 1
    WHERE CodPool = NEW.CodPool;
END $$

CREATE TRIGGER controlla_consumo_medio
BEFORE INSERT ON ConsumoMedio FOR EACH ROW

BEGIN
			SET @targa = (SELECT Targa
							FROM Auto
							WHERE Targa = NEW.Targa);
                            
			IF(@targa = NULL) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Auto non presente nel db';
			END IF;

			IF(NEW.Urbano < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Importo inserito non valido';
			END IF;
            
            IF(NEW.ExtraUrbano < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Importo inserito non valido';
			END IF;
            
            IF(NEW.Misto < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Importo inserito non valido';
			END IF;
            
END $$


CREATE TRIGGER controlla_caratteristiche
BEFORE INSERT ON Caratteristiche FOR EACH ROW 

BEGIN
			IF((NEW.NumPosti < 0) OR (NEW.NumPosti > 9)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Inserire numero di posti valido';
			END IF;
            
            SET @targa = (SELECT Targa
							FROM Auto
							WHERE Targa = NEW.Targa);
                            
			IF(@targa = NULL) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Auto non presente nel db';
			END IF;
            
            IF ((NEW.VelocitaMax < 0) OR (NEW.VelocitaMax > 300)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Velocità inserita non valida';
			END IF;
            
            IF(NEW.AnnoImmatricolazione > current_timestamp() ) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Anno inserito non valido';
			END IF;
            
            IF(NEW.Cilindrata < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Cilindrata inserita non valida';
			END IF;
END $$
            
CREATE TRIGGER controlla_stato_iniziale
BEFORE INSERT ON StatoIniziale FOR EACH ROW

BEGIN
			SET @targa = (SELECT Targa
							FROM Auto
							WHERE Targa = NEW.Targa);
                            
			IF(@targa = NULL) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Auto non presente nel db';
			END IF;
            
            IF(NEW.kmPercorsi < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Km non validi';
			END IF;
            
            IF(NEW.QuantitaCarburante < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Carburante inserito non valido';
			END IF;
            
            IF(NEW.CostoUsura < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'CostoUsura inserito non valido';
			END IF;
END $$

CREATE TRIGGER controlla_optional
BEFORE INSERT ON Optional FOR EACH ROW

BEGIN
			IF(NEW.Peso < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Peso inserito non valido';
			END IF;
            
            IF(NEW.ValutazioneAuto < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'ValutazioneAuto inserita non valida';
			END IF;
            
            IF(NEW.RumoreMedio < 0) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'RumoreMedio inserito non valido';
			END IF;
            
END $$


CREATE TRIGGER aggiorna_servizio_car_sharing
AFTER INSERT ON PrenotazioneDiNoleggio FOR EACH ROW

BEGIN
	UPDATE Auto
    SET ServizioCarSharing = '1'
    WHERE Targa = NEW.Targa;
END $$

CREATE TRIGGER aggiorna_servizio_car_pooling
AFTER INSERT ON Pool FOR EACH ROW

BEGIN
	UPDATE Auto
    SET ServizioPooling = '1'
    WHERE Targa = NEW.Targa;
END $$

CREATE TRIGGER aggiorna_servizio_ride_sharing
AFTER INSERT ON RideSharing FOR EACH ROW

BEGIN
	UPDATE Auto
    SET ServizioRideSharing = '1'
    WHERE Targa = NEW.Targa;
END $$

CREATE TRIGGER aggiorna_stato_utente_dopo_eliminazione_auto
BEFORE DELETE ON Auto FOR EACH ROW

BEGIN
	SET @autorimanenti = (SELECT COUNT (Targa)
							FROM Auto 
							WHERE Id = OLD.Id);

	IF(@autorimanenti = 0) THEN
		UPDATE Utente
		SET Ruolo = 'Fruitore'
		WHERE Id = OLD.Id;
	END IF;
	
END $$

CREATE TRIGGER aggiungi_tragitto
AFTER INSERT ON Pool FOR EACH ROW
BEGIN
	INSERT TragittoPool
    SET CodPool = NEW.CodPool, kmPercorsi = 0;
END $$


CREATE TRIGGER calcolo_km_percorsi
AFTER INSERT ON StradeTragittoPool FOR EACH ROW
BEGIN
	DECLARE chilometraggio INT DEFAULT 0;
    SET chilometraggio = NEW.kmFineStrada - NEW.kmInizioStrada;
	
	UPDATE TragittoPool
    SET kmPercorsi = kmPercorsi + chilometraggio
    WHERE CodPool = NEW.CodPool;
    
        
END $$ 

CREATE TRIGGER aggiorna_km_percorsi_dopo_variazione
AFTER UPDATE ON StradeTragittoPool FOR EACH ROW
BEGIN
	UPDATE TragittoPool
    SET kmPercorsi = kmpercorsi + ABS((NEW.kmInizioStrada - OLD.kmInizioStrada) + ABS(NEW.kmFineStrada - OLD.kmFineStrada))
    WHERE CodPool = NEW.CodPool;
END $$
        

CREATE TRIGGER archivio_chiamate_sharing
AFTER UPDATE ON ChiamataRideSharing FOR EACH ROW

BEGIN
	IF(NEW.Stato = 'RIFIUTATA') THEN
		INSERT ArchivioChiamateSharingRifiutate
        SET CodChiamata = NEW.CodChiamata ,  TimeStamp_= NEW.Timestamp, IdFruitore = NEW.IdFruitore, CodStrada = NEW.CodStradaPartenza, kmStrada = NEW.kmStradaPartenza;
        
	END IF;
    
END $$

CREATE TRIGGER archivio_chiamate_sharing_su_sharing_multiplo
AFTER INSERT ON ChiamataRideSharing FOR EACH ROW

BEGIN
	IF(NEW.Stato = 'RIFIUTATA') THEN
		INSERT ArchivioChiamateSharingRifiutate
        SET CodChiamata = NEW.CodChiamata , TimeStamp = NEW.Timestamp , IdFruitore = NEW.IdFruitore, CodStrada = NEW.CodStradaPartenza, kmStrada = NEW.kmStradaPartenza;
        
	END IF;
    
END $$

CREATE TRIGGER controllo_ride_sharing
BEFORE INSERT ON RideSharing FOR EACH ROW

BEGIN
	 DECLARE postiauto INT DEFAULT 0;

	SET @fruitore = (SELECT COUNT(Id)
					 FROM Utente
                     WHERE Id = NEW.IdFruitore);
                     
	SET @proponente = (SELECT COUNT(U.Id)
						FROM Utente U
							INNER JOIN Auto A ON U.Id = A.Id
						WHERE A.Targa = NEW.Targa);
                        
	IF((@fruitore = 0) OR (@proponente = 0)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente non trovato';
	END IF;
    
    
   -- -- -- -- -- --
	
    SET @utente = (SELECT U.Id
						FROM Utente U
							INNER JOIN Auto A ON U.Id = A.Id
						WHERE A.Targa = NEW.Targa);
	
    SET @ruolo = (SELECT Ruolo
					FROM Utente
					WHERE @utente = Id);
	
    
    IF(@ruolo <> 'Proponente') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non registrato come proponente';
	END IF;
    
    SET @auto = (SELECT A.Targa
					FROM Utente U 
						JOIN Auto A ON U.Id = A.Id
					WHERE NEW.Targa = A.Targa);
                    
	IF(@auto = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nessuna auto registrata per questo utente';
	END IF;
    
    SET postiauto = (SELECT NumPosti
					 FROM Caratteristiche
                     WHERE NEW.Targa = Targa);
    
    IF((NEW.NumPosti < 0) OR (NEW.NumPosti > postiauto)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire un numero di posti valido';
	END IF;
    
    SET NEW.numPosti = postiauto - 1;
		
    
END $$


CREATE TRIGGER controllo_sinistro_sharing	
BEFORE INSERT ON SinistroSharing FOR EACH ROW

BEGIN
	IF(NEW.Orario > current_timestamp()) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire orario valido';
	END IF;
    
    SET @strada = (SELECT CodStrada
					FROM Strada
                    WHERE CodStrada = NEW.CodStrada);
                    
	 SET @chilometro = (SELECT Lunghezza
						FROM Strada
						WHERE CodStrada = NEW.CodStrada);
                    
	IF( (@strada = NULL) OR (NEW.kmStrada < 0) OR (NEW.kmStrada > @chilometro) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
	END IF;
    
    
    IF( (NEW.PercentualeDiResponsabilita < 0) OR (NEW.PercentualeDiResponsabilita > 100) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire percentuale valida';
	END IF;
    
    SET @modello = (SELECT Modello
					FROM Caratteristiche
                    WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.Modello = @modello;
    
    SET @casaautomobilistica = (SELECT CasaProduttrice
								FROM Caratteristiche
                                WHERE Targa = NEW.TargaVeicoloProponente);
	SET NEW.CasaAutomobilistica = @casaautomobilistica;
    
END $$

CREATE TRIGGER controllo_generalita_sinistro_sharing
BEFORE INSERT ON GeneralitaSinistroSharing FOR EACH ROW

BEGIN
	SET @numDocumento = (SELECT NumDocumento
						 FROM Documento D
							JOIN Utente U ON D.Id = U.Id
						 WHERE NEW.NumDocumento = NumDocumento);
                         
	IF((@numDocumento = NULL) OR (@numDocumento <> NEW.NumDocumento) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Documento inserito non valido';
	END IF;
    
    SET @codFiscale = (SELECT CodFiscale
						FROM Utente U
							JOIN Documento D ON U.Id = D.Id
						WHERE NumDocumento = NEW.NumDocumento);
                        
	IF(@codFiscale = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non valido';
	END IF;
    
END$$


CREATE TRIGGER aggiungi_documento_sinistro_sharing		
AFTER INSERT ON GeneralitaSinistroSharing FOR EACH ROW

BEGIN
	INSERT DocumentoDiIdentitaSinistroSharing
    SELECT NumDocumento, Tipologia, Scadenza, EnteRilascio
    FROM Documento
	WHERE NumDocumento = NEW.NumDocumento;
    
END $$

#controlla tracking

CREATE TRIGGER controlla_tracking_noleggio
BEFORE INSERT ON TrackingNoleggio FOR EACH ROW

BEGIN
	SET @targa = (SELECT COUNT(Targa)
				  FROM Auto
                  WHERE Targa = NEW.Targa);
	
    IF(@targa = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Auto non trovata';
	END IF;
    
    SET @strada = (SELECT COUNT(CodStrada)
					FROM Strada
					WHERE CodStrada = NEW.CodStrada);
	
    IF(@strada = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Strada non trovata';
	END IF;
    
    SET @utente = (SELECT U.Id
					FROM Utente U INNER JOIN PrenotazioneDiNoleggio PDN ON U.Id = PDN.IdFruitore
                    WHERE Id = IdFruitore);
	
    SET @password_ = (SELECT Password_
					 FROM Utente
                     WHERE Id = @utente);
	
    IF(@password_ <> NEW.Password_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password inserita errata';
	END IF;
END $$

CREATE TRIGGER controlla_tracking_pool
BEFORE INSERT ON TrackingPool FOR EACH ROW

BEGIN
	SET @targa = (SELECT COUNT(Targa)
				  FROM Auto
                  WHERE Targa = NEW.Targa);
	
    IF(@targa = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Auto non trovata';
	END IF;
    
    SET @strada = (SELECT COUNT(CodStrada)
					FROM Strada
					WHERE CodStrada = NEW.CodStrada);
	
    IF(@strada = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Strada non trovata';
	END IF;
    
    SET @utente = (SELECT Id
					FROM Auto
                    WHERE Targa = NEW.Targa);
	
    SET @password_ = (SELECT Password_
					 FROM Utente
                     WHERE Id = @utente);
	
    IF(@password_ <> NEW.Password_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password inserita errata';
	END IF;
END $$

#Set di trigger che si occupano di gestire l'inserimento automatico delle stelle e delle valutazioni all'interno della tabella generale dell'utente
-- Noleggio
CREATE TRIGGER aggiungi_voto_fruitore_noleggio 
AFTER INSERT ON ValutazioneFruitoreNoleggio FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto, Id = NEW.IdFruitore, Recensione = NEW.Recensione;
END $$ 

	
CREATE TRIGGER aggiungi_stelle_fruitore_noleggio 
AFTER INSERT ON StelleFruitoreNoleggio FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$

CREATE TRIGGER aggiungi_voto_prenotazione_di_noleggio_proponente
AFTER INSERT ON ValutazioneProponenteNoleggio FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto+1000, Id = NEW.IdFruitore, Recensione = NEW.Recensione;
END $$ 

CREATE TRIGGER aggiungi_stelle_proponente_noleggio 
AFTER INSERT ON StelleProponenteNoleggio FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto+1000, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$


-- Ride Sharing

CREATE TRIGGER aggiungi_voto_ride_sharing_fruitore 
AFTER INSERT ON ValutazioneFruitoreRideSharing FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto+2000, Id = NEW.IdFruitore, Recensione = NEW.Recensione;
END $$ 

CREATE TRIGGER aggiungi_stelle_ride_sharing_fruitore #aggiunge automaticamente le stelle dei ride sharing
AFTER INSERT ON StelleFruitoreRideSharing FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto +2000, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$

CREATE TRIGGER aggiungi_voto_ride_sharing_proponente
AFTER INSERT ON ValutazioneProponenteRideSharing FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto+3000, Id = NEW.IdProponente, Recensione = NEW.Recensione;
END $$ 

CREATE TRIGGER aggiungi_stelle_ride_sharing_proponente #aggiunge automaticamente le stelle dei ride sharing
AFTER INSERT ON StelleProponenteRideSharing FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto+3000, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$
    
-- Pool


CREATE TRIGGER aggiungi_stelle_proponente_pool 
AFTER INSERT ON StelleProponentePool FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto+4000, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$


CREATE TRIGGER aggiungi_voto_proponente_pool
AFTER INSERT ON ValutazioneProponentePool FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto+4000, Id = NEW.IdProponente, Recensione = NEW.Recensione;
END $$ 

CREATE TRIGGER aggiungi_stelle_fruitore_pool 
AFTER INSERT ON StelleFruitorePool FOR EACH ROW
		
BEGIN
	INSERT StelleUtente
    SET CodVoto = NEW.CodVoto+5000, Id = NEW.Id, Persona = NEW.Persona, PiacereViaggio = NEW.PiacereViaggio, 	Comportamento = NEW.Comportamento, Serieta = NEW.Serieta;
END $$

CREATE TRIGGER aggiungi_voto_fruitore_pool
AFTER INSERT ON ValutazioneFruitorePool FOR EACH ROW

BEGIN
	INSERT ValutazioneUtente
    SET CodVoto = NEW.CodVoto+5000, Id = NEW.IdProponente, Recensione = NEW.Recensione;
END $$ 
 
CREATE TRIGGER aggiungi_orario_tracking_noleggio
BEFORE INSERT ON TrackingNoleggio FOR EACH ROW
BEGIN
	SET NEW.Timestamp_ = current_timestamp();
END $$



-- Trigger per aggiornamento tracking

CREATE TRIGGER inizio_sharing
AFTER INSERT ON PosizionePartenzaSharing FOR EACH ROW
BEGIN
	DECLARE _targa VARCHAR(7);
    DECLARE _password VARCHAR(100);
    
   SET _targa = (SELECT RS.Targa
					FROM RideSharing RS
						INNER JOIN Auto A ON RS.Targa = A.Targa
                    WHERE CodSharing = NEW.CodSharing);
                    
	SET _password = (SELECT Password_
						FROM Utente U
							INNER JOIN Auto A ON U.Id = A.Id
								INNER JOIN RideSharing RS ON RS.Targa = A.Targa
						WHERE RS.CodSharing = NEW.CodSharing);
                        
    INSERT TrackingSharing
    SET Targa = _targa, CodStrada = NEW.CodStrada,CodSharing = NEW.CodSharing, Password_ = _password, kmStrada = NEW.numChilometro, Timestamp_ = current_timestamp();
    
END $$

                     
CREATE EVENT aggiorna_tracking_sharing
ON SCHEDULE EVERY 5 MINUTE 
DO BEGIN
	DECLARE quanti INT DEFAULT 0;
    DECLARE counter INT DEFAULT 0;
    DECLARE arrivo DATETIME;
    DECLARE partenza DATETIME;
    
    SET quanti = (SELECT COUNT(CodSharing)
					FROM RideSharing);
	
    WHILE (counter <> quanti)
		DO 
        
        SET partenza = (SELECT OraPartenza
						FROM RideSharing
                        WHERE CodSharing = counter + 1);
		
        SET arrivo = (SELECT OraStimatoArrivo
						FROM RideSharing
                        WHERE CodSharing = counter + 1);
		
        SET counter = counter + 1;
        
        IF( (current_timestamp() > partenza) AND (current_timestamp() < arrivo) ) THEN
       
			UPDATE TrackingSharing TS
				INNER JOIN Strada S ON TS.CodStrada = S.CodStrada
            SET kmStrada = kmStrada + 5
            WHERE CodSharing = counter
				AND TS.kmStrada < S.Lunghezza;
		
        END IF;
	END WHILE;
	
END $$

CREATE EVENT aggiorna_tracking_pool
ON SCHEDULE EVERY 5 MINUTE 
DO BEGIN
	DECLARE quanti INT DEFAULT 0;
    DECLARE counter INT DEFAULT 0;
    DECLARE arrivo DATETIME;
    DECLARE partenza DATETIME;
    
    SET quanti = (SELECT COUNT(CodPool)
					FROM Pool);
	
    WHILE (counter <> quanti)
		DO 
        
        SET partenza = (SELECT GiornoPartenza
						FROM Pool
                        WHERE CodPool = counter + 1);
		
        SET arrivo = (SELECT GiornoArrivo
						FROM Pool
                        WHERE CodPool = counter + 1);
		
        SET counter = counter + 1;
        
        IF( (current_timestamp() > partenza) AND (current_timestamp() < arrivo) ) THEN
       
			UPDATE TrackingPool TP
				INNER JOIN Strada S ON S.CodStrada = TP.CodStrada
            SET kmStrada = kmStrada + 5
            WHERE CodPool = counter
				AND TP.kmStrada < S.Lunghezza;
		
        END IF;
	END WHILE;
	
END $$

CREATE TRIGGER controlla_se_strada_finita_sharing
BEFORE UPDATE ON TrackingSharing FOR EACH ROW
BEGIN
	DECLARE kmfine INT DEFAULT 0;
    DECLARE nuovaStrada INT DEFAULT 0;
    
    SET kmfine = (SELECT kmFineStrada
					FROM StradeTragittoSharing
                    WHERE CodSharing = NEW.codSharing
						AND CodStrada = NEW.codStrada);
	
    SET nuovaStrada = (SELECT CodStrada
						FROM StradeTragittoSharing
                        WHERE CodSharing = NEW.CodSharing	
							AND CodStrada = NEW.CodStrada + 1);
                            
	IF( (NEW.kmStrada > kmfine) AND (nuovaStrada <> NULL) ) THEN
		SET NEW.CodStrada = NEW.CodStrada + 1;
	END IF;
END $$


CREATE TRIGGER inizia_pool
AFTER INSERT ON PosizionePartenzaPool FOR EACH ROW
BEGIN
    DECLARE _password VARCHAR(100);
    DECLARE _targa VARCHAR(7);
    DECLARE _utente INT DEFAULT 0;
    
    SET _targa = (SELECT Targa
					FROM Pool
                    WHERE CodPool = NEW.CodPool);
                    
	SET _utente = (SELECT U.id
					FROM Utente U 
						INNER JOIN Auto A ON U.Id = A.Id
					WHERE A.Targa = _targa);
			
	SET _password = (SELECT U.Password_
						FROM Utente U 
						WHERE U.Id = _utente);
	
    INSERT TrackingPool
    SET Targa = _targa , CodStrada = NEW.CodStrada,CodPool = NEW.CodPool, Password_ = _password, kmStrada = NEW.numChilometro, Timestamp_ = current_timestamp();
		
END $$


CREATE TRIGGER controlla_se_strada_finita_pool
BEFORE UPDATE ON TrackingPool FOR EACH ROW
BEGIN
	DECLARE kmfine INT DEFAULT 0;
    DECLARE nuovaStrada INT DEFAULT 0;
    
    SET kmfine = (SELECT kmFineStrada
					FROM StradeTragittoPool
                    WHERE CodPool = NEW.codPool
						AND CodStrada = NEW.codStrada);
	
    SET nuovaStrada = (SELECT CodStrada
						FROM StradeTragittoPool
                        WHERE CodPool = NEW.CodPool
							AND CodStrada = NEW.CodStrada + 1);
                            
	IF( (NEW.kmStrada > kmfine) AND (nuovaStrada <> NULL) ) THEN
		SET NEW.CodStrada = NEW.CodStrada + 1;
	END IF;
END $$

CREATE TRIGGER controlla_chiamata_ride_sharing
BEFORE INSERT ON ChiamataRideSharing FOR EACH ROW
BEGIN
	DECLARE kmfine INT DEFAULT 0;
    DECLARE kminizio INT DEFAULT 0;
    
    SET kmfine = (SELECT MAX(kmFineStrada)
					FROM StradeTragittoSharing 
					WHERE CodStrada = NEW.CodStradaPartenza);
                    
                    
	 SET kminizio = (SELECT MIN(kmInizioStrada)
					FROM StradeTragittoSharing 
					WHERE CodStrada = NEW.CodStradaPartenza);
	
    #TODO: con una precisione di 2 km
    
    IF ( ( NEW.kmStradaPartenza > kmFine) OR (NEW.kmStradaPartenza < kminizio) ) THEN
		INSERT ChiamataSharingMultiplo
        SET CodStradaArrivo = NEW.CodStradaArrivo, kmStradaArrivo = NEW.kmStradaArrivo, CodStradaPartenza = NEW.CodStradaPartenza, kmStradaPartenza = NEW.kmStradaPartenza, TimeStamp = current_timestamp(), IdFruitore = NEW.IdFruitore;
        
        SET NEW.Stato = 'RIFIUTATA';
	
    ELSEIF( (NEW.kmStradaArrivo > kmFine) OR (NEW.kmStradaArrivo < kminizio) ) THEN
		INSERT ChiamataSharingMultiplo
        SET CodStradaArrivo = NEW.CodStradaArrivo, kmStradaArrivo = NEW.kmStradaArrivo, CodStradaPartenza = NEW.CodStradaPartenza, kmStradaPartenza = NEW.kmStradaPartenza, TimeStamp = current_timestamp(), IdFruitore = NEW.IdFruitore;
        
        SET NEW.Stato = 'RIFIUTATA';

	END IF;
    
END $$

CREATE TRIGGER inizio_noleggio
AFTER INSERT ON PosizionePartenzaNoleggio FOR EACH ROW
BEGIN
	DECLARE _targa VARCHAR(7);
	DECLARE _password VARCHAR(128);
    
    SET _targa = (SELECT Targa
					FROM PrenotazioneDiNoleggio
					WHERE CodNoleggio = NEW.CodNoleggio);
                    
	SET _password = (SELECT Password_
						FROM Utente U
							INNER JOIN PrenotazioneDiNoleggio PDN ON PDN.IdFruitore = U.Id
						WHERE PDN.CodNoleggio = NEW.CodNoleggio);
                    
	INSERT TrackingNoleggio
    SET Targa = _targa, CodStrada = NEW.CodStrada, CodNoleggio = NEW.CodNoleggio, Password_ = _password, kmStrada = NEW.numChilometro, Timestamp_ = current_timestamp();
END $$


CREATE EVENT aggiorna_noleggio
ON SCHEDULE EVERY 30 MINUTE
DO BEGIN

	UPDATE TrackingNoleggio TN
		INNER JOIN Strada S ON TN.CodStrada = S.CodStrada
    SET TN.kmStrada = TN.kmStrada + 30
    WHERE Stato = 'APERTO'
		AND TN.kmStrada + 30 < S.Lunghezza;
    
END $$
    
    
    
CREATE EVENT archivia_tutto
ON SCHEDULE EVERY 1 HOUR
DO BEGIN
	DELETE FROM ChiamataRideSharing
    WHERE Stato = 'RIFIUTATA' OR Stato = 'CHIUSA';
    
    DELETE FROM ChiamataSharingMultiplo
	WHERE Stato = 'RIFIUTATA' OR Stato = 'CHIUSA';
    
    DELETE FROM PrenotazioneDiNoleggio
    WHERE Stato = 'CHIUSO' OR Stato = 'RIFIUTATO';
    
    DELETE FROM Pool
    WHERE Stato = 'CHIUSO';
    
END $$
CREATE TRIGGER sharing_multiplo    
AFTER INSERT ON ChiamataSharingMultiplo FOR EACH ROW
BEGIN
   
   DECLARE strada INT DEFAULT 0;
   DECLARE strada2 INT DEFAULT 0;
   DECLARE sharing INT DEFAULT 0;
   DECLARE iniziostrada INT DEFAULT 0;
   DECLARE finestrada INT DEFAULT 0;
   DECLARE finito INT DEFAULT 0;
   
    DECLARE stradetragitto CURSOR FOR
		SELECT CodSharing,kmInizioStrada,kmFineStrada
        FROM StradeTragittoSharing;
        
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
        
        OPEN stradetragitto;
        
preleva: LOOP
			FETCH stradetragitto INTO sharing,iniziostrada,finestrada;
			IF finito = 1 THEN
				LEAVE preleva;
			END IF;
			
            SELECT LEAST(finestrada,I.kmStrada1), CodStrada2 INTO finestrada, strada2
								FROM StradeTragittoSharing STS
									INNER JOIN Incrocio I
								WHERE I.CodStrada1 = STS.CodStrada
									AND STS.kmFineStrada < I.kmStrada1;
			
           
            SET strada = NEW.CodStradaArrivo;
                            
			SET @esiste = (SELECT COUNT(CodSharingMultiplo)
							FROM SharingMultiplo
                            WHERE CodSharing1 = sharing AND CodSharing2 = sharing + 1 AND NEW.IdFruitore = Id
								AND sharing IN (
													SELECT CodSharing
                                                    FROM RideSharing)
									AND sharing + 1 IN (
														SELECT CodSharing
														FROM RideSharing) );
              
            SET @valido = (SELECT COUNT(CodSharingMultiplo)
							FROM SharingMultiplo
                            WHERE CodSharing1 = sharing AND CodSharing2 = sharing + 1);
                            
			SET @controllo = (SELECT COUNT(CodSharing)
								FROM RideSharing
                                WHERE CodSharing = sharing OR CodSharing = sharing + 1);
              
			IF( (@esiste = 0) AND (@valido = 0) AND (@controllo = 2) ) THEN
				INSERT SharingMultiplo
				SET Id = NEW.idFruitore, CodSharing1 = sharing, CodSharing2 = sharing + 1;
			END IF;
																	
			
        END LOOP preleva;
		CLOSE stradetragitto;
 
END $$
        
CREATE PROCEDURE CalcoloOrarioStimatoSharing(IN _codSharing INT, OUT tempoAlChilometro DOUBLE)
BEGIN
	DECLARE esiste INT DEFAULT 0;
    DECLARE TempoStimato DOUBLE DEFAULT 0;
    DECLARE T1 DOUBLE DEFAULT 0;
    DECLARE T2 DOUBLE DEFAULT 0;
    DECLARE T3 DOUBLE DEFAULT 0;
    DECLARE T4 DOUBLE DEFAULT 0;
    DECLARE nAuto INT DEFAULT 0;
    DECLARE nCorsieInMedia INT DEFAULT 0;
    DECLARE nStrade INT DEFAULT 0;
    DECLARE Chilometri INT DEFAULT 0;
    DECLARE densita DOUBLE DEFAULT 0;
    
    
    
    SET esiste = (
					SELECT COUNT(*)
					FROM RideSharing
					WHERE CodSharing = _codSharing
				);
	
    
	IF(esiste = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire uno sharing valido';
    ELSEIF esiste = 1 THEN
			SET nAuto = (
							SELECT	COUNT(DISTINCT TN.Targa)
							FROM 	StradeTragittoSharing STS INNER JOIN TrackingNoleggio TN ON STS.CodStrada = TN.CodStrada
							WHERE	STS.kmInizioStrada <= TN.kmStrada
									AND
									STS.kmFineStrada >= TN.kmStrada
						)
                        +
                        (
							SELECT	COUNT(DISTINCT TS.Targa)
							FROM 	StradeTragittoSharing STS INNER JOIN TrackingSharing TS ON STS.CodStrada = TS.CodStrada
							WHERE	STS.kmInizioStrada <= TS.kmStrada
									AND
									STS.kmFineStrada >= TS.kmStrada
                        )
                        +
                        (
							SELECT	COUNT(DISTINCT TP.Targa)
							FROM 	StradeTragittoSharing STS INNER JOIN TrackingPool TP ON STS.CodStrada = TP.CodStrada
							WHERE	STS.kmInizioStrada <= TP.kmStrada
									AND
									STS.kmFineStrada >= TP.kmStrada
                        );
            
			SET nStrade = 	(
								SELECT	COUNT(*)
								FROM	StradeTragittoSharing
							);
                            
			SET nCorsieInMedia =	(
										SELECT	SUM(S.NumCorsie)
										FROM 	StradeTragittoSharing STS INNER JOIN Strada S ON STS.CodStrada = S.CodStrada
									) / nStrade;
			
            SET Chilometri = (	
								SELECT 	KmPercorsi 
								FROM 	TragittoSharing
                                WHERE 	CodSharing = _codsharing
							);
                                    
			SET densita = nAuto/(Chilometri*nCorsieInMedia);
            
            SELECT  SUM(((LDV.kmFine - STS.kmInizioStrada)/LDV.ValoreLimite)*60) , SUM(LDV.kmFine - STS.kmInizioStrada), STS.CodStrada, LDV.ValoreLimite INTO T1, @lunghezzastrada5, @strada5, @lim5
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio < STS.kmInizioStrada
					AND
					LDV.kmFine <= STS.kmFineStrada
					AND
					LDV.kmFine > STS.kmInizioStrada
			GROUP BY STS.CodSharing;
					
			 IF ( T1 IS NOT NULL AND @strada5 IS NOT NULL AND @lunghezzastrada5 IS NOT NULL AND T1 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada5, TempoMedio = T1, kmPercorsi = @lunghezzastrada5, ValLimite = @lim5;
			END IF;
            
 			SELECT 	SUM(((LDV.kmFine - LDV.kmInizio)/LDV.ValoreLimite)*60), SUM(LDV.kmFine - STS.kmInizioStrada), STS.CodStrada, LDV.ValoreLimite INTO T2, @lunghezzastrada6, @strada6, @lim6
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio >= STS.kmInizioStrada
					AND
					LDV.kmFine < STS.kmFineStrada
			GROUP BY STS.CodSharing;
                    
			 IF ( T2 IS NOT NULL AND @strada6 IS NOT NULL AND @lunghezzastrada6 IS NOT NULL AND T2 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada6, TempoMedio = T2, kmPercorsi = @lunghezzastrada6, ValLimite = @lim6;
			END IF;
                    
			SELECT 	SUM(((STS.kmFineStrada - LDV.kmInizio)/LDV.ValoreLimite)*60), SUM(STS.kmFineStrada - LDV.kmInizio), STS.CodStrada, LDV.ValoreLimite INTO T3, @lunghezzastrada7, @strada7, @lim7
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio > STS.kmInizioStrada
					AND
					LDV.kmFine >= STS.kmFineStrada
					AND
					LDV.kmInizio <= STS.kmFineStrada
			GROUP BY STS.CodSharing;
                    
			 IF ( T3 IS NOT NULL AND @strada7 IS NOT NULL AND @lunghezzastrada7 IS NOT NULL AND T3 < 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada7, TempoMedio = T3, kmPercorsi = @lunghezzastrada7, ValLimite = @lim7;
			END IF;
			
			SELECT 	SUM(((STS.kmFineStrada - STS.kmInizioStrada)/LDV.ValoreLimite)*60), SUM(STS.kmFineStrada - STS.kmInizioStrada), STS.CodStrada , LDV.ValoreLimite INTO T4, @lunghezzastrada8, @strada8, @lim8
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio <= STS.kmInizioStrada
					AND
					LDV.kmFine >= STS.kmFineStrada
			GROUP BY STS.CodSharing; 
                    
			 IF ( T4 IS NOT NULL AND @strada8 IS NOT NULL AND @lunghezzastrada8 IS NOT NULL AND T4 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada8, TempoMedio = T4, kmPercorsi = @lunghezzastrada8, ValLimite = @lim8;
			END IF;
 	
			SET TempoStimato = IFNULL(T1, 0) + IFNULL(T2, 0) + IFNULL(T3, 0) + IFNULL(T4, 0);
            
			
            CASE
				WHEN densita <= 35 THEN
					SET TempoStimato = TempoStimato;
				WHEN densita > 35 AND densita <= 50  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.2;
				WHEN densita > 50 AND densita <= 65  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.4;
				WHEN densita > 65 AND densita <= 80  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.6;
				WHEN densita > 80 AND densita <= 95  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.8;
				WHEN densita > 95  THEN
					SET TempoStimato = TempoStimato + TempoStimato*1;
            END CASE;
            
            SELECT TempoStimato, densita;
			UPDATE RideSharing
			SET OraStimatoArrivo = OraPartenza + INTERVAL TempoStimato MINUTE
            WHERE CodSharing = _codSharing;
            
            SET tempoAlChilometro = TempoStimato;
            
            
    END IF;
END $$

CREATE PROCEDURE CalcoloOrarioStimatoPool(IN _codPool INT, OUT TempoAlChilometro INT)
BEGIN
	DECLARE esiste INT DEFAULT 0;
    DECLARE TempoStimato DOUBLE DEFAULT 0;
    DECLARE T1 DOUBLE DEFAULT 0;
    DECLARE T2 DOUBLE DEFAULT 0;
    DECLARE T3 DOUBLE DEFAULT 0;
    DECLARE T4 DOUBLE DEFAULT 0;
    DECLARE nAuto INT DEFAULT 0;
    DECLARE nCorsieInMedia INT DEFAULT 0;
    DECLARE nStrade INT DEFAULT 0;
    DECLARE Chilometri INT DEFAULT 0;
    DECLARE densita DOUBLE DEFAULT 0;
    
    
    
    SET esiste = (
					SELECT COUNT(*)
					FROM Pool
					WHERE CodPool = _codPool
				);
	
    
	IF(esiste = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire uno sharing valido';
    ELSEIF esiste = 1 THEN
			SET nAuto = (
							SELECT	COUNT(DISTINCT TN.Targa)
							FROM 	StradeTragittoPool STP INNER JOIN TrackingNoleggio TN ON STP.CodStrada = TN.CodStrada
							WHERE	STP.kmInizioStrada <= TN.kmStrada
									AND
									STP.kmFineStrada >= TN.kmStrada
						)
                        +
                        (
							SELECT	COUNT(DISTINCT TS.Targa)
							FROM 	StradeTragittoPool STP INNER JOIN TrackingSharing TS ON STP.CodStrada = TS.CodStrada
							WHERE	STP.kmInizioStrada <= TS.kmStrada
									AND
									STP.kmFineStrada >= TS.kmStrada
                        )
                        +
                        (
							SELECT	COUNT(DISTINCT TP.Targa)
							FROM 	StradeTragittoPool STP INNER JOIN TrackingPool TP ON STP.CodStrada = TP.CodStrada
							WHERE	STP.kmInizioStrada <= TP.kmStrada
									AND
									STP.kmFineStrada >= TP.kmStrada
                        );
            
			SET nStrade = 	(
								SELECT	COUNT(*)
								FROM	StradeTragittoPool
							);
                            
			SET nCorsieInMedia =	(
										SELECT	SUM(S.NumCorsie)
										FROM 	StradeTragittoPool STP INNER JOIN Strada S ON STP.CodStrada = S.CodStrada
									) / nStrade;
			
            SET Chilometri = (	
								SELECT 	KmPercorsi 
								FROM 	TragittoPool
                                WHERE 	CodPool = _codPool
							);
                                    
			SET densita = nAuto/(Chilometri*nCorsieInMedia);
            
            SELECT LDV.ValoreLimite, SUM(((LDV.kmFine - STP.kmInizioStrada)/LDV.ValoreLimite)*60),SUM(LDV.kmFine - STP.kmInizioStrada), STP.CodStrada INTO @lim ,T1, @lunghezzastrada, @strada
			FROM	StradeTragittoPool STP INNER JOIN LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
			WHERE 	STP.CodPool = _codPool
					AND 
					LDV.kmInizio < STP.kmInizioStrada
					AND
					LDV.kmFine <= STP.kmFineStrada
					AND
					LDV.kmFine > STP.kmInizioStrada;
			
            IF ( T1 IS NOT NULL AND @strada IS NOT NULL AND @lunghezzastrada IS NOT NULL AND T1 <> 0)  THEN
				 INSERT TempoMedioPercorrenza
				 SET CodStrada = @strada, TempoMedio = T1, kmPercorsi = @lunghezzastrada, ValLimite = @lim;
			END IF; 
					
 			SELECT LDV.ValoreLimite, SUM(((LDV.kmFine - LDV.kmInizio)/LDV.ValoreLimite)*60),SUM(LDV.kmFine - STP.kmInizioStrada), STP.CodStrada INTO @lim2, T2, @lunghezzastrada2, @strada2
			FROM	StradeTragittoPool STP INNER JOIN LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
			WHERE 	STP.CodPool = _codPool
					AND 
					LDV.kmInizio >= STP.kmInizioStrada
					AND
					LDV.kmFine < STP.kmFineStrada;
	
                    
			 IF ( T2 IS NOT NULL AND @strada2 IS NOT NULL AND @lunghezzastrada2 IS NOT NULL AND T2 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada2, TempoMedio = T2, kmPercorsi = @lunghezzastrada2, ValLimite = @lim2;
			END IF; 
 					
			SELECT LDV.ValoreLimite , SUM(((STP.kmFineStrada - LDV.kmInizio)/LDV.ValoreLimite)*60), SUM(STP.kmFineStrada - LDV.kmInizio), STP.CodStrada INTO @lim3, T3, @lunghezzastrada3, @strada3
			FROM	StradeTragittoPool STP INNER JOIN LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
			WHERE 	STP.CodPool = _codPool
					AND 
					LDV.kmInizio > STP.kmInizioStrada
					AND
					LDV.kmFine >= STP.kmFineStrada
					AND
					LDV.kmInizio <= STP.kmFineStrada;
                    
			IF ( T3 IS NOT NULL AND @strada3 IS NOT NULL AND @lunghezzastrada3 IS NOT NULL AND T3 <> 0) THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada3, TempoMedio = T3, kmPercorsi = @lunghezzastrada3, ValLimite = @lim3;
			END IF; 
					
			
			SELECT 	LDV.ValoreLimite ,SUM(((STP.kmFineStrada - STP.kmInizioStrada)/LDV.ValoreLimite)*60), SUM((STP.kmFineStrada - STP.kmInizioStrada)), STP.CodStrada INTO @lim4, T4, @lunghezzastrada4, @strada4
			FROM	StradeTragittoPool STP INNER JOIN LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
			WHERE 	STP.CodPool = _codPool
					AND 
					LDV.kmInizio <= STP.kmInizioStrada
					AND
					LDV.kmFine >= STP.kmFineStrada;
		
				
			IF ( T4 IS NOT NULL AND @strada4 IS NOT NULL AND @lunghezzastrada4 IS NOT NULL AND T4 <> 0) THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada4, TempoMedio = T4, kmPercorsi = @lunghezzastrada4, ValLimite = @lim4;
                
                SELECT @lunghezzastrada3, T3, @strada3;
			END IF;
 	
			SET TempoStimato = IFNULL(T1, 0) + IFNULL(T2, 0) + IFNULL(T3, 0) + IFNULL(T4, 0);
            
			
            CASE
				WHEN densita <= 35 THEN
					SET TempoStimato = TempoStimato;
				WHEN (densita > 35) AND (densita <= 50)  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.2;
				WHEN densita > 50 AND densita <= 65  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.4;
				WHEN densita > 65 AND densita <= 80  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.6;
				WHEN densita > 80 AND densita <= 95  THEN
					SET TempoStimato = TempoStimato + TempoStimato*0.8;
				WHEN densita > 95  THEN
					SET TempoStimato = TempoStimato + TempoStimato*1;
            END CASE;
            
            SELECT TempoStimato, densita;
			UPDATE Pool
			SET GiornoArrivo = GiornoPartenza + INTERVAL TempoStimato MINUTE
            WHERE CodPool = _codPool;
            
            SET tempoAlChilometro = TempoStimato;
            
    END IF;
END $$

CREATE PROCEDURE CalcolaCodaSharing(IN _codsharing INT)
BEGIN
	DECLARE _tempoMedio DOUBLE UNSIGNED DEFAULT 0;
    DECLARE counter INT UNSIGNED DEFAULT 0;
    DECLARE massimo INT UNSIGNED DEFAULT 0;
    
    INSERT MinutiAlChilometro
    SELECT _codsharing, TMP.CodStrada, AVG(TMP.kmPercorsi/(TMP.ValLimite))*60 , 0
	FROM TempoMedioPercorrenza TMP
		INNER JOIN StradeTragittoSharing STS ON TMP.CodStrada = STS.CodStrada
	WHERE STS.CodSharing = _codsharing
	GROUP BY TMP.CodStrada;
    
    SET massimo = (SELECT MAX(CodStrada) 
						FROM StradeTragittoSharing
                        WHERE CodSharing = _codsharing);
    
    ciclo : LOOP
    
		SET counter = counter + 1;
        
		IF(counter > massimo) THEN
			LEAVE ciclo;
		END IF;
        
#calcola il tempo che ci sarebbe voluto in condizioni ideali a percorrere lo selezionato e lo confronta con i tempi registrati
        
        UPDATE MinutiAlChilometro MAC
			JOIN TempoMedioPercorrenza TMP
		SET MAC.RitardoStimato = MAC.TempoMedioPercorrenzaStrada - (SELECT AVG(kmPercorsi/ValLimite)*60
																		FROM TempoMedioPercorrenza
                                                                        WHERE CodStrada = counter)
																		
        WHERE MAC.CodStrada = counter;
        
	END LOOP ciclo;
			
END $$

CREATE PROCEDURE CalcolaCodaPool(IN _codpool INT)
BEGIN
	DECLARE _tempoMedio DOUBLE UNSIGNED DEFAULT 0;
    DECLARE counter INT UNSIGNED DEFAULT 0;
    DECLARE massimo INT UNSIGNED DEFAULT 0;
    
    INSERT MinutiAlChilometro
    SELECT _codpool+1000, TMP.CodStrada, AVG(TMP.kmPercorsi/(TMP.ValLimite))*60 , 0
	FROM TempoMedioPercorrenza TMP
		INNER JOIN StradeTragittoPool STP ON TMP.CodStrada = STP.CodStrada
	WHERE STP.CodPool = _codpool
	GROUP BY TMP.CodStrada;
    
    SET massimo = (SELECT MAX(CodStrada) 
						FROM StradeTragittoPool
                        WHERE CodPool = _codpool);
    
    ciclo : LOOP
    
		SET counter = counter + 1;
        
		IF(counter > massimo) THEN
			LEAVE ciclo;
		END IF;
        
#calcola il tempo che ci sarebbe voluto in condizioni ideali a percorrere lo selezionato e lo confronta con i tempi registrati
        
        UPDATE MinutiAlChilometro MAC
			JOIN TempoMedioPercorrenza TMP
		SET MAC.RitardoStimato = MAC.TempoMedioPercorrenzaStrada - (SELECT AVG(kmPercorsi/ValLimite)*60
																		FROM TempoMedioPercorrenza
                                                                        WHERE CodStrada = counter)
																		
        WHERE MAC.CodStrada = counter;
        
	END LOOP ciclo;
			
END $$

 
 -- Ranking
 
CREATE PROCEDURE Classifica()
BEGIN
	SELECT @row_number := @row_number + 1 AS Posizione, U.*
	FROM (SELECT @row_number := 0) AS N, Utente U
    ORDER BY MediaVoto DESC;
END $$

CREATE EVENT bonus
ON SCHEDULE EVERY 1 YEAR 
DO BEGIN
	DECLARE sinistrinoleggi INT DEFAULT 0;
    DECLARE sinistrisharing INT DEFAULT 0;
    DECLARE sinistripool INT DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    DECLARE utente INT DEFAULT 0;
        
	DECLARE utenti CURSOR FOR
		SELECT Id
        FROM Utenti;
        
	 DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
	
    OPEN utenti;
preleva: LOOP
	FETCH utenti INTO utente;
    
    IF finito = 1 THEN
		LEAVE preleva;
	END IF;
    
    SET sinistrinoleggi = (SELECT COUNT(*)
							FROM SinistroNoleggio
                            WHERE IdGuidatore = utente);
                            
	SET @targa = (SELECT targa
				FROM Auto
                WHERE Id = utente);
                
	SET sinistrisharing = (SELECT COUNT(*)
							FROM SinistroSharing
                            WHERE TargaVeicoloProponente = @targa);
                            
	SET sinistripool = (SELECT COUNT(*)
							FROM SinistroPool
                            WHERE TargaVeicoloProponente = @targa);
                            
                            
	IF( (sinistrisharing + sinistipool + sinistrinoleggi) = 0 ) THEN
		UPDATE Utente
        SET mediavoto = mediavoto + 0.1
        WHERE Id = utente
			AND Stato = 'ATTIVO'
				AND mediaVoto < 4.9;
	END IF;
    
    END LOOP preleva;
    CLOSE utenti;
    
END $$

CREATE TRIGGER chiudi_chiamata_sharing
AFTER INSERT ON AdesioniRideSharing FOR EACH ROW
BEGIN
	UPDATE ChiamataRideSharing
    SET Stato = 'CHIUSA'
    WHERE IdFruitore = NEW.IdUtente;
END $$

CREATE EVENT chiudi_chiamate_vecchie
ON SCHEDULE EVERY 1 day
DO BEGIN
	UPDATE ChiamataRideSharing
    SET Stato = 'RIFIUTATA'
    WHERE TimeStamp <= current_timestamp() - INTERVAL 48 HOUR;
END $$

CREATE TRIGGER inserisci_sharing_vecchi
BEFORE DELETE ON RideSharing FOR EACH ROW
BEGIN
	INSERT ArchivioSharingVecchi
    SET CodSharing = OLD.CodSharing, OrarioPartenza = OLD.OraPartenza, Targa = OLD.Targa;
END $$

CREATE EVENT chiudi
ON SCHEDULE EVERY 1 HOUR
DO BEGIN

	DELETE FROM RideSharing
    WHERE current_timestamp() > OraStimatoArrivo;
    
    UPDATE Pool
    SET Stato = 'CHIUSO'
    WHERE current_timestamp() > GiornoArrivo;
    
    UPDATE PrenotazioneDiNoleggio
    SET Stato = 'CHIUSO'
    WHERE current_timestamp()  > DataFine;
    
END $$
    
    
	
CREATE PROCEDURE RichiediVariazione(IN _idrichiedente INT UNSIGNED, IN _strada INT UNSIGNED, IN _km INT, IN _codPool INT UNSIGNED)
BEGIN
	DECLARE _flessibilita ENUM ('BASSO','MEDIO','ALTO');
    DECLARE _variazioniprecedenti INT UNSIGNED DEFAULT 0;
    DECLARE _kmrichiesta INT DEFAULT 0;
    DECLARE _kmpartenza INT DEFAULT 0;
    DECLARE _stradapartenza INT UNSIGNED DEFAULT 0;
	DECLARE _kmarrivo INT UNSIGNED DEFAULT 0;
    DECLARE _stradaarrivo INT UNSIGNED DEFAULT 0;
    
	INSERT Variazione
    SET IdRichiedente = _idrichiedente, CodStrada = _strada, kmAggiunta = _km, CodPool = _codPool;
    
    SET _flessibilita = (SELECT GradoFlessibilita
							FROM Pool
							WHERE CodPool = _codPool);
                            
	SET _variazioniprecedenti = (SELECT COUNT(*)
									FROM Variazione
									WHERE IdRichiedente = _idrichiedente
										AND CodPool = _codPool
											AND Stato = 'ACCETTATO');
                                            
	SELECT numChilometro, CodStrada INTO _kmpartenza, _stradapartenza
	FROM PosizionePartenzaPool
	WHERE CodPool = _codPool;
    
    SELECT numChilometro, CodStrada INTO _kmarrivo, _stradaarrivo
	FROM PosizioneArrivoPool
	WHERE CodPool = _codPool;
    
    #se il richiedente ha già effettuato troppo richieste di variazioni, rifiuta la richiesta attuale
	CASE
		WHEN ( (_variazioniprecedenti >= 1) AND (_flessibilita = 'BASSO') ) THEN
			UPDATE Variazione
            SET Stato = 'RIFIUTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
		WHEN ( (_variazioniprecedenti >= 2) AND (_flessibilita = 'MEDIO') ) THEN
			UPDATE Variazione
            SET Stato = 'RIFIUTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
		WHEN ( ( _variazioniprecedenti >= 3) AND (_flessibilita = 'ALTO') ) THEN
			UPDATE Variazione
            SET Stato = 'RIFIUTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
		ELSE
			UPDATE Variazione
            SET Stato = 'in attesa'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
	END CASE;
    
    #controllo che la variazione non passi troppo lontano dal tragitto che percorre il pool
    
    -- caso in cui chiedo la variazione nella strada di partenza
	IF (_strada = _stradapartenza) THEN
		SET _kmrichiesta = ABS(_km - _kmpartenza)*2;       #perchè dopo devo tornare indietro
    
    -- caso in cui chiedo la variazionne nella strada di arrivo 
    ELSEIF (_strada = _stradaarrivo) THEN
		SET _kmrichiesta = ABS(_km - _kmarrivo)*2; 
        
	END IF;
    
    -- devo vedere se è raggiungibille
    
	IF ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) ) THEN
    
		SET _kmrichiesta = (SELECT ABS(_km - CAST(I.kmStrada2 AS SIGNED))
							FROM Incrocio I
								INNER JOIN StradeTragittoPool STP ON STP.CodStrada = I.CodStrada1
							WHERE I.CodStrada2 = _strada);
                                
    END IF;
    
  
    CASE
		WHEN ( (_flessibilita = 'BASSO') AND (_kmrichiesta <= 2) AND ((_stradapartenza = _strada) OR (_stradaarrivo = _strada)) ) THEN
			
			IF(_stradapartenza = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
                
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
			
           
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_flessibilita = 'MEDIA') AND (_kmrichiesta <= 4) AND ((_stradapartenza = _strada) OR (_stradaarrivo = _strada))) THEN
        
			IF(_stradapartenza = _strada) THEN

			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
			
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_flessibilita = 'ALTO') AND (_kmrichiesta <= 6) AND  ((_stradapartenza = _strada) OR (_stradaarrivo = _strada))) THEN
        
			IF(_stradapartenza = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) AND (_flessibilita = 'BASSO') AND (_kmrichiesta <= 2) ) THEN
			
            INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
		WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) AND (_flessibilita = 'MEDIO') AND (_kmrichiesta <= 4) ) THEN
			
			INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
			
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
		
        WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo)  AND (_flessibilita = 'ALTO') AND (_kmrichiesta <= 6) ) THEN
            
            INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
            
            UPDATE Variazione
            SET Stato = 'ACCETTATA'
            WHERE IdRichiedente = _idrichiedente
				AND CodPool = _codPool;
                
		ELSE
			BEGIN
				UPDATE Variazione
				SET Stato = 'RIFIUTATA'
				WHERE IdRichiedente = _idrichiedente
					AND CodPool = _codPool;
            END;
            
		END CASE;
    
END $$

CREATE PROCEDURE nuova_strada_percorsa_noleggio(IN _codnoleggio INT, IN _strada INT, IN _km INT, IN _targa VARCHAR(7))
BEGIN
	DECLARE _password VARCHAR(128);
    
    SET _password = (SELECT U.Password_
						FROM Utente U
							INNER JOIN Auto A ON U.Id = A.Id
						WHERE A.Targa = _targa);
                        
	UPDATE TrackingNoleggio     
    SET Stato = 'CONCLUSO'
    WHERE CodNoleggio = _codnoleggio;
                        
	INSERT TrackingNoleggio
    SET CodNoleggio = _codnoleggio, CodStrada = _strada, kmStrada = _km, Password_ = _password, Targa = _targa, Timestamp_ = current_timestamp();
    
END $$


CREATE TRIGGER controlla_cod_fiscale
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN	
	IF( (CHAR_LENGTH(NEW.CodFiscale) <> 16) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codice fiscale inserito errato';
	END IF;
END $$

DELIMITER ;
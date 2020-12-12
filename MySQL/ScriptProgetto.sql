DROP DATABASE IF EXISTS Progetto;
CREATE DATABASE Progetto;

USE PROGETTO;

-- Scheduler degli eventi
SET GLOBAL event_scheduler = ON;

-- Mac OS
SET sql_mode = '';
SET SQL_SAFE_UPDATES = 0;


-- INFORMAZIONI GENERALI -- 
CREATE TABLE Utente (
    Password_ VARCHAR(128) NOT NULL,
    Ruolo ENUM('Fruitore', 'Proponente') DEFAULT 'Fruitore',
    Indirizzo VARCHAR(100) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    CodFiscale VARCHAR(16) NOT NULL,
    NumeroTelefono VARCHAR(12) NOT NULL,
    MediaVoto VARCHAR(3) DEFAULT 0,
    Stato ENUM('ATTIVO', 'INATTIVO') DEFAULT 'INATTIVO',
    DataIscrizione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    Affidabilita ENUM('non calcolata', 'BASSA', 'MEDIA', 'ALTA') DEFAULT 'non calcolata',
    NomeUtente VARCHAR(40),
    PRIMARY KEY (NomeUtente),
    UNIQUE (CodFiscale)
);

CREATE TABLE Account (
	NomeUtente VARCHAR(40),
    Password_ VARCHAR(128) NOT NULL,
    DomandaRiserva TEXT,
    RispostaRiserva TEXT,
    
    PRIMARY KEY (NomeUtente),
    FOREIGN KEY (NomeUtente)
		REFERENCES Utente(NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE Documento (
    NumDocumento VARCHAR(16) NOT NULL,
	NomeUtente VARCHAR(40),
    Tipologia VARCHAR(50) NOT NULL,
    Scadenza DATE NOT NULL,
    EnteRilascio VARCHAR(50) NOT NULL,
    PRIMARY KEY (NumDocumento , NomeUtente),
    FOREIGN KEY (NomeUtente)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

-- Valutazione generale dell'utente
CREATE TABLE ValutazioneUtente (
    CodVoto INT UNSIGNED AUTO_INCREMENT,
    IdVotato VARCHAR(40) NOT NULL,
    IdVotante VARCHAR(40) NOT NULL,
    Recensione VARCHAR(200) NOT NULL,
    Persona DOUBLE UNSIGNED NOT NULL,
    PiacereViaggio DOUBLE UNSIGNED NOT NULL,
    Serieta DOUBLE UNSIGNED NOT NULL,
    Comportamento DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodVoto , IdVotato),
    FOREIGN KEY (IdVotato)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE,
	FOREIGN KEY (IdVotante)
		REFERENCES Utente(NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE Auto (
    Targa VARCHAR(7) NOT NULL,
    Id VARCHAR(40) NOT NULL,
    ServizioRideSharing BOOL DEFAULT FALSE,
    ServizioCarSharing BOOL DEFAULT FALSE,
    ServizioPooling BOOL DEFAULT FALSE,
    PRIMARY KEY (Targa),
    FOREIGN KEY (Id)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE ConsumoMedio (
    Targa VARCHAR(7) NOT NULL,
    Urbano DOUBLE UNSIGNED NOT NULL,
    ExtraUrbano DOUBLE UNSIGNED NOT NULL,
    Misto DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (Targa),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE Caratteristiche (
    Targa VARCHAR(7) NOT NULL,
    NumPosti INT UNSIGNED NOT NULL,
    VelocitaMax DOUBLE UNSIGNED NOT NULL,
    AnnoImmatricolazione INT UNSIGNED NOT NULL,
    Alimentazione VARCHAR(29) NOT NULL,
    Cilindrata DOUBLE UNSIGNED NOT NULL,
    Modello VARCHAR(29) NOT NULL,
    CasaProduttrice VARCHAR(29) NOT NULL,
	RumoreMedio DOUBLE UNSIGNED NOT NULL,
	Comfort INT DEFAULT 0,
    PRIMARY KEY (Targa),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE StatoIniziale (
    Targa VARCHAR(7) NOT NULL,
    KmPercorsi DOUBLE UNSIGNED NOT NULL,
    QuantitaCarburante DOUBLE UNSIGNED NOT NULL,
    CostoUsura DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (Targa),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE Optional (
    Targa VARCHAR(7) NOT NULL,
    Peso DOUBLE UNSIGNED NOT NULL,
    Connettivita BOOL DEFAULT 0,
    Tavolino BOOL DEFAULT 0,
    TettoInVetro BOOL DEFAULT 0,
    Bagagliaio DOUBLE UNSIGNED NOT NULL,
    ValutazioneAuto DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (Targa),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

-- STRADE -- 
CREATE TABLE Strada (
    CodStrada INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Tipologia VARCHAR(30) NOT NULL,
    Categorizzazione VARCHAR(30) DEFAULT NULL,
    ClassificazioneTecnica VARCHAR(30) NOT NULL,
    Nome VARCHAR(50) DEFAULT NULL,
    Lunghezza DOUBLE UNSIGNED NOT NULL,
    NumCorsie INT UNSIGNED NOT NULL DEFAULT 2,
    NumSensi INT UNSIGNED NOT NULL DEFAULT 1,
    NumCarreggiate INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (CodStrada)
);

CREATE TABLE CorsieDiImmissione (
    CodImmissione INT UNSIGNED AUTO_INCREMENT NOT NULL,
    CodStrada1 INT UNSIGNED NOT NULL,
    CodStrada2 INT UNSIGNED NOT NULL,
    kmStrada1 DOUBLE UNSIGNED NOT NULL,
    kmStrada2 DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodImmissione),
    FOREIGN KEY (CodStrada1)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE,
    FOREIGN KEY (CodStrada2)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE Pedaggio (
    CodPedaggio INT UNSIGNED AUTO_INCREMENT,
    CodStrada INT UNSIGNED NOT NULL,
    Importo DOUBLE UNSIGNED NOT NULL,
    kmStrada1 DOUBLE UNSIGNED NOT NULL,
    kmStrada2 DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodPedaggio),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE LimitiDiVelocita (
    CodLimite INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ValoreLimite INT UNSIGNED NOT NULL,
    kmFine INT UNSIGNED NOT NULL,
    kmInizio INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodLimite),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE Incrocio (
    CodStrada1 INT UNSIGNED NOT NULL,
    CodStrada2 INT UNSIGNED NOT NULL,
    kmStrada1 INT UNSIGNED NOT NULL,
    kmStrada2 INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada1 , CodStrada2 , kmStrada1 , kmStrada2),
    FOREIGN KEY (CodStrada1)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE,
    FOREIGN KEY (CodStrada2)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

-- CAR SHARING --
CREATE TABLE PrenotazioneDiNoleggio (
    CodNoleggio INT UNSIGNED NOT NULL AUTO_INCREMENT,
    DataInizio DATETIME NOT NULL,
    DataFine DATETIME NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    Targa VARCHAR(7) NOT NULL,
    Prezzo INT UNSIGNED NOT NULL,
    QuantitaCarburanteFinale DOUBLE UNSIGNED DEFAULT 0.0,
    Stato ENUM('ATTIVO', 'CHIUSO', 'RIFIUTATO') DEFAULT 'ATTIVO',
    PRIMARY KEY (CodNoleggio),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE NO ACTION
);

CREATE TABLE ArchivioPrenotazioniRifiutate (
    CodNoleggio INT UNSIGNED NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    Targa VARCHAR(7) NOT NULL,
    PRIMARY KEY (CodNoleggio),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE,
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE ArchivioPrenotazioniVecchie (
    CodNoleggio INT UNSIGNED NOT NULL,
    DataInizio TIMESTAMP NOT NULL,
    DataFine TIMESTAMP NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    Targa VARCHAR(7) NOT NULL,
    PRIMARY KEY (CodNoleggio),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE,
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE TragittoNoleggio (
    CodTragitto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodNoleggio INT UNSIGNED NOT NULL,
    KmPercorsi DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodTragitto),
	FOREIGN KEY (CodNoleggio)
		REFERENCES PrenotazioneDiNoleggio(CodNoleggio)
        ON DELETE NO ACTION
);

CREATE TABLE PosizioneArrivoNoleggio (
    CodStrada INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodNoleggio INT UNSIGNED NOT NULL,
    NumChilometro INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodNoleggio),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE PosizionePartenzaNoleggio (
    CodStrada INT UNSIGNED NOT NULL,
    CodNoleggio INT UNSIGNED NOT NULL,
    NumChilometro DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodNoleggio),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE TrackingNoleggio (
    Targa VARCHAR(7) NOT NULL,
    CodStrada INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodNoleggio INT UNSIGNED NOT NULL,
    Password_ VARCHAR(128) NOT NULL,
    kmStrada INT UNSIGNED NOT NULL,
    Timestamp_ TIMESTAMP NOT NULL,
    Stato ENUM('CONCLUSO', 'APERTO') DEFAULT 'APERTO',
    PRIMARY KEY (CodNoleggio , Targa , CodStrada , kmstrada , Timestamp_),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION
);

CREATE TABLE SinistroNoleggio (
    CodSinistro INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Modello VARCHAR(24) NOT NULL,
    CasaAutomobilistica VARCHAR(24) NOT NULL,
    TargaVeicoloProponente VARCHAR(7) NOT NULL,
    IdGuidatore VARCHAR(40) NOT NULL,
    Orario TIMESTAMP NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    KmStrada INT UNSIGNED NOT NULL,
    Dinamica VARCHAR(200) NOT NULL,
    PercentualeDiResponsabilita INT NOT NULL,
    PRIMARY KEY (CodSinistro),
    FOREIGN KEY (TargaVeicoloProponente)
        REFERENCES Auto (Targa)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION,
    FOREIGN KEY (IdGuidatore)
        REFERENCES Utente (NomeUtente)
        ON DELETE NO ACTION
);

-- CAR POOLING -- 
CREATE TABLE Pool (
    CodPool INT UNSIGNED NOT NULL AUTO_INCREMENT,
    GiornoPartenza TIMESTAMP NOT NULL,
    Stato ENUM('ATTIVO', 'CHIUSO','PARTITO') DEFAULT 'ATTIVO',
    GiornoArrivo TIMESTAMP,
    Targa VARCHAR(7) NOT NULL,
    CostoCarburante DOUBLE DEFAULT 0,
    GradoFlessibilita ENUM('BASSO', 'MEDIO', 'ALTO'),
    NumPosti INT UNSIGNED NOT NULL,
    Prezzo DOUBLE UNSIGNED DEFAULT 0,
    PRIMARY KEY (CodPool),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE AdesioniPool (
    CodPool INT UNSIGNED NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    PRIMARY KEY (CodPool , IdFruitore),
    FOREIGN KEY (CodPool)
        REFERENCES Pool (CodPool)
        ON DELETE CASCADE,
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE NO ACTION
);

CREATE TABLE TragittoPool (
    CodTragitto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    KmPercorsi DOUBLE UNSIGNED NOT NULL,
    CodPool INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodTragitto),
    FOREIGN KEY (CodPool)
        REFERENCES Pool (CodPool)
);

CREATE TABLE TrackingPool (
    Targa VARCHAR(7) NOT NULL,
    CodPool INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    Password_ VARCHAR(128) NOT NULL,
    kmStrada INT UNSIGNED NOT NULL,
    Timestamp_ TIMESTAMP NOT NULL,
    PRIMARY KEY (Targa , CodPool , CodStrada , kmStrada , Timestamp_),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodPool)
        REFERENCES Pool (CodPool)
        ON DELETE NO ACTION
);

CREATE TABLE StradeTragittoPool (
    CodStrada INT UNSIGNED NOT NULL,
    CodPool INT UNSIGNED NOT NULL,
    kmInizioStrada INT UNSIGNED NOT NULL,
    kmFineStrada INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodPool),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodPool)
        REFERENCES Pool (CodPool)
        ON DELETE CASCADE
);

CREATE TABLE PosizioneArrivoPool (
    CodPool INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    numChilometro DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodPool),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE PosizionePartenzaPool (
    CodPool INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    numChilometro DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodPool),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE SinistroPool (
    CodSinistro INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Modello VARCHAR(24) NOT NULL,
    CasaAutomobilistica VARCHAR(24) NOT NULL,
    TargaVeicoloProponente VARCHAR(7) NOT NULL,
    Orario TIMESTAMP NOT NULL,
    KmStrada INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    Dinamica VARCHAR(200) NOT NULL,
    PercentualeDiResponsabilita INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodSinistro),
    FOREIGN KEY (TargaVeicoloProponente)
        REFERENCES Auto (Targa)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION
);

CREATE TABLE ArchivioPoolVecchi (
    CodPool INT UNSIGNED NOT NULL,
    GradoFlessibilita ENUM('BASSO', 'MEDIO', 'ALTO'),
    GiornoArrivo TIMESTAMP NOT NULL,
    GiornoPartenza TIMESTAMP NOT NULL,
    Targa VARCHAR(7) NOT NULL,
    PRIMARY KEY (CodPool),
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE CASCADE
);

CREATE TABLE Variazione (
    CodVariazione INT UNSIGNED NOT NULL AUTO_INCREMENT,
    IdRichiedente INT UNSIGNED NOT NULL,
    Codstrada INT UNSIGNED NOT NULL,
    kmAggiunta INT UNSIGNED NOT NULL,
    CodPool INT UNSIGNED NOT NULL,
    Stato ENUM('ACCETTATA', 'RIFIUTATA', 'in attesa') DEFAULT 'in attesa',
    PRIMARY KEY (CodVariazione),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE,
    FOREIGN KEY (CodPool)
        REFERENCES Pool (CodPool)
        ON DELETE CASCADE
);

-- RIDE SHARING -- 
CREATE TABLE ChiamataRideSharing (
    CodChiamata INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodStradaArrivo INT UNSIGNED NOT NULL,
    kmStradaArrivo INT UNSIGNED NOT NULL,
    CodStradaPartenza INT UNSIGNED NOT NULL,
    kmStradaPartenza INT UNSIGNED NOT NULL,
    Stato ENUM('ATTIVA', 'CHIUSA', 'RIFIUTATA') DEFAULT 'ATTIVA',
    TimeStamp TIMESTAMP NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    PRIMARY KEY (CodChiamata),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE ArchivioChiamateSharingRifiutate (
    CodChiamata INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    kmStrada INT UNSIGNED NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    TimeStamp TIMESTAMP NOT NULL,
    PRIMARY KEY (CodChiamata),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE,
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (codStrada)
        ON DELETE CASCADE
);

CREATE TABLE RideSharing (
    CodSharing INT UNSIGNED NOT NULL AUTO_INCREMENT,
    IdFruitore VARCHAR(40) NOT NULL,
    OraPartenza TIMESTAMP NOT NULL,
    OraStimatoArrivo TIMESTAMP,
    Targa VARCHAR(7) NOT NULL,
    CostoCarburante DOUBLE,
    Prezzo VARCHAR(4),
    NumPosti INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodSharing),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE PosizionePartenzaSharing (
    CodSharing INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    numChilometro DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodSharing),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE PosizioneArrivoSharing (
    CodSharing INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    numChilometro DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodSharing),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE CASCADE
);

CREATE TABLE TragittoSharing (
    CodTragitto INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodSharing INT UNSIGNED NOT NULL,
    KmPercorsi DOUBLE UNSIGNED NOT NULL,
    PRIMARY KEY (CodTragitto),
    FOREIGN KEY (CodSharing)
        REFERENCES RideSharing (CodSharing)
        ON DELETE CASCADE
);

CREATE TABLE AdesioniRideSharing (
    CodSharing INT UNSIGNED NOT NULL,
    IdUtente VARCHAR(40) NOT NULL,
    PRIMARY KEY (CodSharing , IdUtente),
    FOREIGN KEY (CodSharing)
        REFERENCES RideSharing (CodSharing)
        ON DELETE CASCADE,
    FOREIGN KEY (IdUtente)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE ArchivioSharingVecchi (
    CodSharing INT UNSIGNED NOT NULL,
    OrarioPartenza TIMESTAMP NOT NULL,
    Targa VARCHAR(7) NOT NULL,
    PRIMARY KEY (CodSharing),
    FOREIGN KEY (CodSharing)
        REFERENCES RideSharing (CodSharing)
        ON DELETE CASCADE
);

CREATE TABLE TrackingSharing (
    Targa VARCHAR(7) NOT NULL,
    CodStrada INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodSharing INT UNSIGNED NOT NULL,
    Password_ VARCHAR(128) NOT NULL,
    kmStrada INT UNSIGNED NOT NULL,
    Timestamp_ TIMESTAMP NOT NULL,
    PRIMARY KEY (Targa ,CodSharing , CodStrada , kmStrada , Timestamp_),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION,
    FOREIGN KEY (Targa)
        REFERENCES Auto (Targa)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodSharing)
        REFERENCES RideSharing (CodSharing)
        ON DELETE NO ACTION
);

CREATE TABLE SinistroSharing (
    CodSinistro INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Modello VARCHAR(24) NOT NULL,
    CasaAutomobilistica VARCHAR(24) NOT NULL,
    TargaVeicoloProponente VARCHAR(7) NOT NULL,
    Orario TIMESTAMP NOT NULL,
    KmStrada INT UNSIGNED NOT NULL,
    CodStrada INT UNSIGNED NOT NULL,
    Dinamica VARCHAR(200) NOT NULL,
    PercentualeDiResponsabilita INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodSinistro),
    FOREIGN KEY (TargaVeicoloProponente)
        REFERENCES Auto (Targa)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION
);

CREATE TABLE StradeTragittoSharing (
    CodStrada INT UNSIGNED NOT NULL,
    CodSharing INT UNSIGNED NOT NULL,
    kmInizioStrada INT UNSIGNED NOT NULL,
    kmFineStrada INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodStrada , CodSharing),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION,
    FOREIGN KEY (CodSharing)
        REFERENCES RideSharing (CodSharing)
        ON DELETE CASCADE
);
 
 -- SHARING MULTIPLO -- 
CREATE TABLE ChiamataSharingMultiplo (
    CodChiamata INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodStradaArrivo INT UNSIGNED NOT NULL,
    kmStradaArrivo INT UNSIGNED NOT NULL,
    CodStradaPartenza INT UNSIGNED NOT NULL,
    kmStradaPartenza INT UNSIGNED NOT NULL,
    Stato ENUM('ATTIVA', 'CHIUSA', 'RIFIUTATA') DEFAULT 'ATTIVA',
    TimeStamp TIMESTAMP NOT NULL,
    IdFruitore VARCHAR(40) NOT NULL,
    PRIMARY KEY (CodChiamata),
    FOREIGN KEY (IdFruitore)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE
);

CREATE TABLE SharingMultiplo (
    CodSharingMultiplo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Id VARCHAR(40) NOT NULL,
    CodSharing1 INT UNSIGNED,
    CodSharing2 INT UNSIGNED,
    PRIMARY KEY (CodSharingMultiplo),
    FOREIGN KEY (Id)
        REFERENCES Utente (NomeUtente)
        ON DELETE CASCADE,
	FOREIGN KEY (CodSharing1)
		REFERENCES RideSharing(CodSharing)
		ON DELETE NO ACTION,
	FOREIGN KEY (CodSharing2)
		REFERENCES RideSharing(CodSharing)
		ON DELETE NO ACTION
);

 -- Materialized view per statistiche sui tempi di percorrenza
CREATE TABLE TempoMedioPercorrenza (
    CodTempo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodStrada INT UNSIGNED NOT NULL,
    TempoMedio DOUBLE UNSIGNED NOT NULL,
    kmPercorsi DOUBLE UNSIGNED NOT NULL,
    ValLimite INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodTempo),
    FOREIGN KEY (CodStrada)
        REFERENCES Strada (CodStrada)
        ON DELETE NO ACTION
);

CREATE TABLE MinutiAlChilometro (
    CodCoda INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CodStrada INT UNSIGNED NOT NULL,
    TempoMedioPercorrenzaStrada DOUBLE UNSIGNED NOT NULL,
    RitardoStimato VARCHAR(100) DEFAULT 0,
    PRIMARY KEY (CodCoda , CodStrada),
    FOREIGN KEY (codStrada)
        REFERENCES Strada(CodStrada)
        ON DELETE CASCADE
);

 -- -------------------------------------------------------- TRIGGER --------------------------------------------------------
DELIMITER $$

-- Aggiornamento ridondanza
CREATE TRIGGER aggiorna_media_voto
AFTER INSERT ON ValutazioneUtente FOR EACH ROW
BEGIN
	SET @media_Persona = (SELECT AVG(Persona)
									 FROM ValutazioneUtente
									 WHERE IdVotato = new.IdVotato
                                     );
	
	SET @media_PiacereViaggio = (SELECT AVG(PiacereViaggio)
									 FROM ValutazioneUtente
									 WHERE IdVotato = new.IdVotato
                                     );		
                                     
	SET @media_Serieta =  (SELECT AVG(Serieta)
									 FROM ValutazioneUtente
									 WHERE IdVotato = new.IdVotato
                                     );
	SET @media_Comportamento =  (SELECT AVG(Comportamento)
									 FROM ValutazioneUtente
									 WHERE IdVotato = new.IdVotato
                                     );
	
    SET @media = (@media_Persona + @media_PiacereViaggio + @media_Serieta + @media_Comportamento)/4;
    
    IF((@media < 0) OR (@media > 5)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire voto valido';
    END IF;
    
UPDATE Utente 
SET 
    MediaVoto = @media
WHERE
    NomeUtente = NEW.IdVotato;

END $$

CREATE TRIGGER aggiorna_ruolo
AFTER INSERT ON Auto FOR EACH ROW

BEGIN
	SET @ruolo = (SELECT Ruolo
				  FROM Utente
                  WHERE NomeUtente = NEW.Id);
	
    IF(@ruolo = 'Fruitore') THEN
		UPDATE Utente
        SET Ruolo = 'Proponente'
        WHERE NomeUtente = NEW.Id;
	END IF;
END $$

CREATE TRIGGER aggiorna_posti_disponibili_pool
AFTER INSERT ON AdesioniPool FOR EACH ROW
BEGIN
	UPDATE Pool
    SET NumPosti = NumPosti - 1
    WHERE CodPool = NEW.CodPool;
END $$

CREATE TRIGGER aggiungi_consumo_iniziale
BEFORE INSERT ON PrenotazioneDiNoleggio FOR EACH ROW
BEGIN
	SET @carburante = (SELECT QuantitaCarburante
						FROM StatoIniziale
                        WHERE Targa = NEW.Targa);
	
    SET NEW.QuantitaCarburanteFinale = @carburante;
    
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
		WHERE NomeUtente = OLD.Id;
	END IF;
	
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

-- ----------------------------------------------------------- BUSINESS RULES -----------------------------------------------------------------------
CREATE TRIGGER controllo_incrocio
BEFORE INSERT ON Incrocio FOR EACH ROW
BEGIN
	DECLARE strada1 INT DEFAULT 0;
    DECLARE strada2 INT DEFAULT 0;
    DECLARE km1 INT DEFAULT 0;
    DECLARE km2 INT DEFAULT 0;
    
    SET strada1 = (SELECT COUNT(CodStrada)
					FROM Strada
                    WHERE CodStrada = NEW.CodStrada1);
                    
	SET strada2 = (SELECT COUNT(CodStrada)
					FROM Strada
                    WHERE CodStrada = NEW.CodStrada2);
	
    IF (strada1 = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
    END IF;
    
    IF (strada2 = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire strada valida';
    END IF;
    
    SET km1 = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada1);
	
      SET km2 = (SELECT Lunghezza
				FROM Strada
                WHERE CodStrada = NEW.CodStrada2);
                
		IF(km1 < NEW.kmStrada1)	THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Inserire chilometro valido';
		END IF;
        
        IF(km2 < NEW.kmStrada2)	THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Inserire chilometro valido';
		END IF;
END $$

CREATE TRIGGER controllo_stelle
BEFORE INSERT ON ValutazioneUtente FOR EACH ROW
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
SET 
    Stato = 'ATTIVO'
WHERE
    NomeUtente = NEW.NomeUtente;
    
END $$ 

-- Rende inattivi tutti gli utenti che hanno documenti scaduti
CREATE EVENT controllo_periodico_scadenza_documenti
ON SCHEDULE EVERY 1 DAY
DO BEGIN

	UPDATE Utente U
    SET U.Stato = 'INATTIVO'
    WHERE current_date() > (
							SELECT D.dataScadenza
                            FROM Documento D
                            WHERE D.NomeUtente = U.NomeUtente
							);
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

	SET @fruitore = (SELECT NomeUtente
					FROM Utente
					WHERE NomeUtente = NEW.IdFruitore);
                    
	IF(@fruitore = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Immettere un utente esistente';
	END IF;
	
    SET @ruolo = (SELECT Ruolo 
				FROM Utente U
					INNER JOIN Auto A ON U.NomeUtente = A.Id
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
						JOIN Auto A ON U.NomeUtente = A.Id
					WHERE NEW.Targa = Targa);
                    
	IF(@auto = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nessuna auto registrata per questo utente';
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

CREATE TRIGGER controllo_pool
BEFORE INSERT ON Pool FOR EACH ROW

BEGIN
	DECLARE postiauto INT DEFAULT 0;
    
    SET @proponente = (SELECT U.NomeUtente
						FROM Utente U
							INNER JOIN Auto A ON U.NomeUtente = A.Id
						WHERE NEW.Targa = A.Targa);
                        
	IF(@proponente = NULL) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente non trovato';
	END IF;
    
    SET @ruolo = (SELECT Ruolo
					FROM Utente
					WHERE NomeUtente = @proponente);
	
    
    IF(@ruolo <> 'Proponente') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non registrato come proponente';
	END IF;
    
    SET @auto = (SELECT Targa
					FROM Utente U 
						JOIN Auto A ON U.NomeUtente = A.Id
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

/* ARCHIVIAZIONE */
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
 
CREATE TRIGGER aggiungi_costo_carburante_pool
BEFORE INSERT ON Pool FOR EACH ROW

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

CREATE TRIGGER controlla_patente
AFTER INSERT ON Auto FOR EACH ROW
BEGIN
	DECLARE esiste INT DEFAULT 0;
    
    SET esiste = (
					SELECT COUNT(*)
                    FROM Documento
					WHERE NomeUtente = NEW.Id
						AND (Tipologia = 'Patente b1'
							OR Tipologia = 'Patente b2'
								OR Tipologia = 'Patente c1'
									OR Tipologia = 'Patente c2')
					);
	IF (esiste = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Patente non inserita';
	END IF;
END$$

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
            
END $$

CREATE TRIGGER aggiungi_tragitto
AFTER INSERT ON Pool FOR EACH ROW
BEGIN
	INSERT TragittoPool
    SET CodPool = NEW.CodPool, kmPercorsi = 0;
END $$

-- ----------------------------------------------------------- ARCHIVIAZIONE ----------------------------------------------------------------------
CREATE TRIGGER archivia_prenotazioni_di_noleggio
AFTER UPDATE ON PrenotazioneDiNoleggio FOR EACH ROW

BEGIN
	IF(NEW.Stato = 'CHIUSO') THEN
		INSERT ArchivioPrenotazioniVecchie
		SET CodNoleggio = NEW.CodNoleggio, DataInizio = NEW.DataInizio, DataFine = NEW.DataFine, IdFruitore = NEW.IdFruitore, Targa = NEW.Targa;
		DELETE FROM PrenotazioneDiNoleggio 
WHERE
    CodNoleggio = NEW.CodNoleggio;
    END IF;
    
    IF(NEW.Stato = 'RIFIUTATO') THEN
		INSERT ArchivioPrenotazioniRifiutate
		SET CodNoleggio = NEW.CodNoleggio, IdFruitore = NEW.IdFruitore, Targa = NEW.Targa;
		DELETE FROM PrenotazioneDiNoleggio 
WHERE
    CodNoleggio = NEW.CodNoleggio;
    END IF;
    
    
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

	SET @fruitore = (SELECT COUNT(*)
					 FROM Utente
                     WHERE NomeUtente = NEW.IdFruitore);
                     
	SET @proponente = (SELECT COUNT(*)
						FROM Utente U
							INNER JOIN Auto A ON U.NomeUtente = A.Id
						WHERE A.Targa = NEW.Targa);
                        
	IF((@fruitore = 0) OR (@proponente = 0)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente non trovato';
	END IF;
	
    SET @utente = (SELECT U.NomeUtente
						FROM Utente U
							INNER JOIN Auto A ON U.NomeUtente = A.Id
						WHERE A.Targa = NEW.Targa);
	
    SET @ruolo = (SELECT Ruolo
					FROM Utente
					WHERE NomeUtente = @utente);
	
    
    IF(@ruolo <> 'Proponente') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Utente inserito non registrato come proponente';
	END IF;
    
    SET @auto = (SELECT A.Targa
					FROM Utente U 
						JOIN Auto A ON U.NomeUtente = A.Id
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
    
    SET @utente = (SELECT U.NomeUtente
					FROM Utente U INNER JOIN PrenotazioneDiNoleggio PDN ON U.NomeUtente = PDN.IdFruitore
                    WHERE U.NomeUtente = IdFruitore);
	
    SET @password_ = (SELECT Password_
					 FROM Utente
                     WHERE NomeUtente = @utente);
	
    IF(@password_ <> NEW.Password_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password inserita errata';
	END IF;
END $$

CREATE TRIGGER aggiungi_orario_tracking_noleggio
BEFORE INSERT ON TrackingNoleggio FOR EACH ROW
BEGIN
	SET NEW.Timestamp_ = current_timestamp();
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
                     WHERE NomeUtente = @utente);
	
    IF(@password_ <> NEW.Password_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password inserita errata';
	END IF;
END $$

-- Trigger per aggiornamento tracking --
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
							INNER JOIN Auto A ON U.NomeUtente = A.Id
								INNER JOIN RideSharing RS ON RS.Targa = A.Targa
						WHERE RS.CodSharing = NEW.CodSharing);
                        
    INSERT TrackingSharing
    SET Targa = _targa, CodStrada = NEW.CodStrada,CodSharing = NEW.CodSharing, Password_ = _password, kmStrada = NEW.numChilometro, Timestamp_ = current_timestamp();
    
END $$

CREATE TRIGGER controlla_cod_fiscale
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN	
	IF( (CHAR_LENGTH(NEW.CodFiscale) <> 16) ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codice fiscale inserito errato';
	END IF;
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

-- inserita la posizione di partenza, fa partire il tracking di un pool
CREATE TRIGGER inizia_pool
AFTER INSERT ON PosizionePartenzaPool FOR EACH ROW
BEGIN
    DECLARE _password VARCHAR(100);
    DECLARE _targa VARCHAR(7);
    DECLARE _utente VARCHAR(40);
    
    SET _targa = (SELECT Targa
					FROM Pool
                    WHERE CodPool = NEW.CodPool);
                    
	SET _utente = (SELECT U.NomeUtente
					FROM Utente U 
						INNER JOIN Auto A ON U.NomeUtente = A.Id
					WHERE A.Targa = _targa);
			
	SET _password = (SELECT U.Password_
						FROM Utente U 
						WHERE U.NomeUtente = _utente);
	
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

-- quando inserisco la posizione di partenza di un noleggio faccio partire l'attività di tracking
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
							INNER JOIN PrenotazioneDiNoleggio PDN ON PDN.IdFruitore = U.NomeUtente
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
    
    
-- funzione di archiviazione    
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

-- Dopo aver inserito una chiamata di ride sharing il trigger controlla se ci sono sharing attivi che possono raggiungere DIRETTAMENTE la destinazione.
-- In caso negativo, viene aggiunta automaticamente la chiamata per uno sharing multiplo.
CREATE TRIGGER controlla_fattibilià_ride_sharing
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

-- dopo aver inserito la chiamata per uno sharing multiplo controlla se quest'ultimo è fattibile attraverso gli sharing aperti 
CREATE TRIGGER sharing_multiplo    
AFTER INSERT ON ChiamataSharingMultiplo FOR EACH ROW
BEGIN
   
   DECLARE strada INT DEFAULT 0;
   DECLARE strada2 INT DEFAULT 0;
   DECLARE _id INT DEFAULT 0;
   DECLARE _sharing1 INT DEFAULT 0;
   DECLARE _sharing2 INT DEFAULT 0;
   DECLARE finito INT DEFAULT 0;
   DECLARE sharing_partenza INT DEFAULT 0;
   DECLARE sharing_arrivo INT DEFAULT 0;
        
	DECLARE sharingmultipli CURSOR FOR
			SELECT Id,CodSharing1, CodSharing2
			FROM SharingMultiplo;
            
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
        
        
        -- Trovo, se esistono, gli sharing di partenza e arrivo, min = creato prima rispetto agli altri
        SELECT MIN(CodSharing) INTO sharing_partenza
        FROM StradeTragittoSharing
        WHERE CodStrada = NEW.CodStradaPartenza
			AND NEW.kmStradaPartenza BETWEEN KmInizioStrada AND kmFineStrada;
        
        SELECT MIN(CodSharing) INTO sharing_arrivo
        FROM StradeTragittoSharing
        WHERE CodStrada = NEW.CodStradaArrivo
			AND NEW.kmStradaArrivo BETWEEN KmInizioStrada AND kmFineStrada;
        
        
        INSERT INTO SharingMultiplo(Id,CodSharing1,CodSharing2) VALUES(NEW.IdFruitore, sharing_partenza,NULL);
        INSERT INTO SharingMultiplo(Id,CodSharing1,CodSharing2) VALUES(NEW.IdFruitore,NULL,sharing_arrivo);
        
        
         OPEN sharingmultipli;
        
preleva: LOOP
			FETCH sharingmultipli INTO _id,_sharing1,_sharing2;
			
            IF finito = 1 THEN
				LEAVE preleva;
			END IF;
			
            #TODO: da controllare
            UPDATE SharingMultiplo
			SET CodSharing2 = (
								SELECT min(STS1.CodSharing)
								FROM StradeTragittoSharing STS1
									INNER JOIN Incrocio I ON STS1.CodStrada = I.CodStrada2
								WHERE I.kmStrada1 BETWEEN STS1.kmInizioStrada AND STS1.kmFineStrada
									AND STS1.CodSharing <> sharing_partenza
							  )
			WHERE CodSharing2 IS NULL;
                
			
             UPDATE SharingMultiplo
			SET CodSharing1 = (
								SELECT MIN(STS1.CodSharing)
								FROM StradeTragittoSharing STS1
									INNER JOIN Incrocio I ON STS1.CodStrada = I.CodStrada2
								WHERE I.kmStrada1 BETWEEN STS1.kmInizioStrada AND STS1.kmFineStrada
									AND STS1.CodSharing <> sharing_partenza
							  )
			WHERE CodSharing1 IS NULL;
			
            
        END LOOP preleva;
		CLOSE sharingmultipli;
        
        DELETE FROM SharingMultiplo
        WHERE CodSharing1 = CodSharing2;
 
		
END $$

-- -------------------------------------------------------------- ANALYTIC --------------------------------------------------------------
-- calcolo dell'orario di arrivo stimato di uno sharing, per commenti e spiegazione vedere il calcolo dell'orario di arrivo stimato del pool (sotto)
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
			-- conteggio auto che stanno effettuando tracking su quella strada
			SET nAuto = (
							SELECT	COUNT(DISTINCT TN.Targa)
							FROM 	StradeTragittoSharing STS INNER JOIN TrackingNoleggio TN ON STS.CodStrada = TN.CodStrada
							WHERE	STS.kmInizioStrada <= TN.kmStrada
									AND
									STS.kmFineStrada >= TN.kmStrada #TODO: mettere controllo stato tracking
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
            -- numero strade percorse
			SET nStrade = 	(
								SELECT	COUNT(*)
								FROM	StradeTragittoSharing
                                WHERE CodSharing = _codSharing
							);
            
            -- media corsie per strada
			SET nCorsieInMedia =	(
										SELECT	SUM(S.NumCorsie)
										FROM 	StradeTragittoSharing STS INNER JOIN Strada S ON STS.CodStrada = S.CodStrada
                                        WHERE STS.CodSharing = _codSharing
									) / nStrade;
			
            -- totale chilometri percorsi
            SET Chilometri = (	
								SELECT 	KmPercorsi 
								FROM 	TragittoSharing
                                WHERE 	CodSharing = _codsharing
							);
                  
			
			SET densita = nAuto/(Chilometri*nCorsieInMedia);
            
SELECT 
    SUM(((LDV.kmFine - STS.kmInizioStrada) / LDV.ValoreLimite) * 60),
    SUM(LDV.kmFine - STS.kmInizioStrada),
    STS.CodStrada,
    LDV.ValoreLimite
INTO T1 , @lunghezzastrada5 , @strada5 , @lim5 FROM
    StradeTragittoSharing STS
        INNER JOIN
    LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
WHERE
    STS.CodSharing = _codSharing
        AND LDV.kmInizio < STS.kmInizioStrada
        AND LDV.kmFine <= STS.kmFineStrada
        AND LDV.kmFine > STS.kmInizioStrada
GROUP BY STS.CodSharing;
					
			 IF ( T1 IS NOT NULL AND @strada5 IS NOT NULL AND @lunghezzastrada5 IS NOT NULL AND T1 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada5, TempoMedio = T1, kmPercorsi = @lunghezzastrada5, ValLimite = @lim5;
			END IF;
            
 			SELECT 
    SUM(((LDV.kmFine - LDV.kmInizio) / LDV.ValoreLimite) * 60),
    SUM(LDV.kmFine - STS.kmInizioStrada),
    STS.CodStrada,
    LDV.ValoreLimite
INTO T2 , @lunghezzastrada6 , @strada6 , @lim6 FROM
    StradeTragittoSharing STS
        INNER JOIN
    LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
WHERE
    STS.CodSharing = _codSharing
        AND LDV.kmInizio >= STS.kmInizioStrada
        AND LDV.kmFine < STS.kmFineStrada
GROUP BY STS.CodSharing;
                    
			 IF ( T2 IS NOT NULL AND @strada6 IS NOT NULL AND @lunghezzastrada6 IS NOT NULL AND T2 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada6, TempoMedio = T2, kmPercorsi = @lunghezzastrada6, ValLimite = @lim6;
			END IF;
                    
			SELECT 
    SUM(((STS.kmFineStrada - LDV.kmInizio) / LDV.ValoreLimite) * 60),
    SUM(STS.kmFineStrada - LDV.kmInizio),
    STS.CodStrada,
    LDV.ValoreLimite
INTO T3 , @lunghezzastrada7 , @strada7 , @lim7 FROM
    StradeTragittoSharing STS
        INNER JOIN
    LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
WHERE
    STS.CodSharing = _codSharing
        AND LDV.kmInizio > STS.kmInizioStrada
        AND LDV.kmFine >= STS.kmFineStrada
        AND LDV.kmInizio <= STS.kmFineStrada
GROUP BY STS.CodSharing;
                    
			 IF ( T3 IS NOT NULL AND @strada7 IS NOT NULL AND @lunghezzastrada7 IS NOT NULL AND T3 < 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada7, TempoMedio = T3, kmPercorsi = @lunghezzastrada7, ValLimite = @lim7;
			END IF;
			
			SELECT 
    SUM(((STS.kmFineStrada - STS.kmInizioStrada) / LDV.ValoreLimite) * 60),
    SUM(STS.kmFineStrada - STS.kmInizioStrada),
    STS.CodStrada,
    LDV.ValoreLimite
INTO T4 , @lunghezzastrada8 , @strada8 , @lim8 FROM
    StradeTragittoSharing STS
        INNER JOIN
    LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
WHERE
    STS.CodSharing = _codSharing
        AND LDV.kmInizio <= STS.kmInizioStrada
        AND LDV.kmFine >= STS.kmFineStrada
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
SET 
    OraStimatoArrivo = OraPartenza + INTERVAL TempoStimato MINUTE
WHERE
    CodSharing = _codSharing;
            
            SET tempoAlChilometro = TempoStimato;
            
            
    END IF;
END $$

-- calcola l'orario di arrivo stimato di un pool
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
    
    
    -- controllo se pool esiste
    SET esiste = (
					SELECT COUNT(*)
					FROM Pool
					WHERE CodPool = _codPool
				);
	
    
	IF(esiste = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire uno sharing valido';
    ELSEIF esiste = 1 THEN
			-- calcolo il numero di auto che si trovano sul percorso sul quale deve passare il pool
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
            -- il nummero di strade sul quale passa il pool
			SET nStrade = 	(
								SELECT	COUNT(*)
								FROM	StradeTragittoPool
                                WHERE CodPool = _codPool
							);
                            
			SET nCorsieInMedia =	(
										SELECT	SUM(S.NumCorsie)
										FROM 	StradeTragittoPool STP INNER JOIN Strada S ON STP.CodStrada = S.CodStrada
                                        WHERE STP.CodPool = _codPool
									) / nStrade;
			
            SET Chilometri = (	
								SELECT 	KmPercorsi 
								FROM 	TragittoPool
                                WHERE 	CodPool = _codPool
							);
                            
            -- calcolo la densità media delle auto lungo il tragitto                        
			SET densita = nAuto/(Chilometri*nCorsieInMedia);
            
            
            -- a seconda dei limiti e della densita calcolata, ricavo un tempo di percorrenza che inserisco nella materialized view per fini statistici
SELECT 
    LDV.ValoreLimite,
    SUM(((LDV.kmFine - STP.kmInizioStrada) / LDV.ValoreLimite) * 60),
    SUM(LDV.kmFine - STP.kmInizioStrada),
    STP.CodStrada
INTO @lim , T1 , @lunghezzastrada , @strada FROM
    StradeTragittoPool STP
        INNER JOIN
    LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
WHERE
    STP.CodPool = _codPool
        AND LDV.kmInizio < STP.kmInizioStrada
        AND LDV.kmFine <= STP.kmFineStrada
        AND LDV.kmFine > STP.kmInizioStrada
GROUP BY STP.CodPool;
			
            IF ( T1 IS NOT NULL AND @strada IS NOT NULL AND @lunghezzastrada IS NOT NULL AND T1 <> 0)  THEN
				 INSERT TempoMedioPercorrenza
				 SET CodStrada = @strada, TempoMedio = T1, kmPercorsi = @lunghezzastrada, ValLimite = @lim;
			END IF;
					
 			SELECT 
    LDV.ValoreLimite,
    SUM(((LDV.kmFine - LDV.kmInizio) / LDV.ValoreLimite) * 60),
    SUM(LDV.kmFine - STP.kmInizioStrada),
    STP.CodStrada
INTO @lim2 , T2 , @lunghezzastrada2 , @strada2 FROM
    StradeTragittoPool STP
        INNER JOIN
    LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
WHERE
    STP.CodPool = _codPool
        AND LDV.kmInizio >= STP.kmInizioStrada
        AND LDV.kmFine < STP.kmFineStrada
GROUP BY STP.CodPool;
	
                    
			 IF ( T2 IS NOT NULL AND @strada2 IS NOT NULL AND @lunghezzastrada2 IS NOT NULL AND T2 <> 0)  THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada2, TempoMedio = T2, kmPercorsi = @lunghezzastrada2, ValLimite = @lim2;
			END IF;
 					
			SELECT 
    LDV.ValoreLimite,
    SUM(((STP.kmFineStrada - LDV.kmInizio) / LDV.ValoreLimite) * 60),
    SUM(STP.kmFineStrada - LDV.kmInizio),
    STP.CodStrada
INTO @lim3 , T3 , @lunghezzastrada3 , @strada3 FROM
    StradeTragittoPool STP
        INNER JOIN
    LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
WHERE
    STP.CodPool = _codPool
        AND LDV.kmInizio > STP.kmInizioStrada
        AND LDV.kmFine >= STP.kmFineStrada
        AND LDV.kmInizio <= STP.kmFineStrada
GROUP BY STP.CodPool;
                    
			IF ( T3 IS NOT NULL AND @strada3 IS NOT NULL AND @lunghezzastrada3 IS NOT NULL AND T3 <> 0) THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada3, TempoMedio = T3, kmPercorsi = @lunghezzastrada3, ValLimite = @lim3;
			END IF;
					
			
			SELECT 
    LDV.ValoreLimite,
    SUM(((STP.kmFineStrada - STP.kmInizioStrada) / LDV.ValoreLimite) * 60),
    SUM((STP.kmFineStrada - STP.kmInizioStrada)),
    STP.CodStrada
INTO @lim4 , T4 , @lunghezzastrada4 , @strada4 FROM
    StradeTragittoPool STP
        INNER JOIN
    LimitiDiVelocita LDV ON STP.CodStrada = LDV.CodStrada
WHERE
    STP.CodPool = _codPool
        AND LDV.kmInizio <= STP.kmInizioStrada
        AND LDV.kmFine >= STP.kmFineStrada
GROUP BY STP.CodPool;
		
				
			IF ( T4 IS NOT NULL AND @strada4 IS NOT NULL AND @lunghezzastrada4 IS NOT NULL AND T4 <> 0) THEN
				INSERT TempoMedioPercorrenza
				SET CodStrada = @strada4, TempoMedio = T4, kmPercorsi = @lunghezzastrada4, ValLimite = @lim4;
                
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
				ELSE 
					SET TempoStimato = TempoStimato;
            END CASE;
            
SELECT TempoStimato, densita;
			UPDATE Pool 
SET 
    GiornoArrivo = GiornoPartenza + INTERVAL TempoStimato MINUTE
WHERE
    CodPool = _codPool;
            
            SET tempoAlChilometro = TempoStimato;
            
    END IF;
END $$

-- funzione che calcola la discrepanza tra il tempo ideale di percorrenza di una strada e l'effettivo tempo di percorrenza, rilevando quindi la presenza di code
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
        
UPDATE MinutiAlChilometro MAC
        JOIN
    TempoMedioPercorrenza TMP 
SET 
    MAC.RitardoStimato = MAC.TempoMedioPercorrenzaStrada - (SELECT 
            AVG(kmPercorsi / ValLimite) * 60
        FROM
            TempoMedioPercorrenza
        WHERE
            CodStrada = counter)
WHERE
    MAC.CodStrada = counter;
        
	END LOOP ciclo;
			
END $$

-- funzione che calcola la discrepanza tra il tempo ideale di percorrenza di una strada e l'effettivo tempo di percorrenza, rilevando quindi la presenza di code
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
        
UPDATE MinutiAlChilometro MAC
        JOIN
    TempoMedioPercorrenza TMP 
SET 
    MAC.RitardoStimato = MAC.TempoMedioPercorrenzaStrada - (SELECT 
            AVG(kmPercorsi / ValLimite) * 60
        FROM
            TempoMedioPercorrenza
        WHERE
            CodStrada = counter)
WHERE
    MAC.CodStrada = counter;
        
	END LOOP ciclo;
			
END $$

-- ------------------------------------------------------------	RANKING --------------------------------------------------------------------
CREATE PROCEDURE ClassificaRowNumber()
BEGIN

-- con row_number
	SELECT @row_number := @row_number + 1 AS Posizione, U.*
	FROM (SELECT @row_number := 0) AS N, Utente U
    ORDER BY MediaVoto DESC;
END $$

-- Rank senza gap
CREATE PROCEDURE Ranking()
BEGIN
	SELECT IF(@ruolo = U.Ruolo, IF(@media = U.mediaVoto,
		 							@rank_ := @rank_ + LEAST(0, @gap := @gap + 1),
									@rank_ := @rank_ + GREATEST(@gap, @gap := 1) + LEAST(0, @media := U.mediaVoto)
								   )
			,
             @rank_ := 1 + LEAST(0, @ruolo := U.Ruolo) + LEAST(0, @media = U.mediaVoto) + LEAST(0, @gap := 1)
            ) AS Classifica ,
            U.Ruolo,
            U.NomeUtente,
            U.Nome,
            U.Cognome,
            U.MediaVoto,
            U.Affidabilita
	FROM Utente U,
			(SELECT (@ruolo := '')) AS N
	ORDER BY U.Ruolo, U.MediaVoto desc;
END $$
			
-- attribuisce un punteggio bonus ad ogni utente che nel corso di un anno non ha commesso  incidenti
CREATE EVENT bonus
ON SCHEDULE EVERY 1 YEAR 
DO BEGIN
	DECLARE sinistrinoleggi INT DEFAULT 0;
    DECLARE sinistrisharing INT DEFAULT 0;
    DECLARE sinistripool INT DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    DECLARE utente INT DEFAULT 0;
        
	DECLARE utenti CURSOR FOR
		SELECT NomeUtente
        FROM Utente;
        
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
        WHERE NomeUtente = utente
			AND Stato = 'ATTIVO'
				AND mediaVoto < 4.9
					AND date(dataIscrizione) < current_date() - INTERVAL 1 YEAR;
	END IF;
    
    END LOOP preleva;
    CLOSE utenti;
    
END $$
    
-- ----------------------------------------------------------------- ARCHIVIAZIONE ------------------------------------------------------------

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


-- -------------------------------------------------------------- UTILITA' -----------------------------------------------------------------------
-- Fornisce le informazioni relative al traffico
CREATE PROCEDURE info_traffico(_codstrada INT)
BEGIN
	DECLARE ritardo DOUBLE DEFAULT 0;
    
    SET ritardo = ( SELECT AVG(RitardoStimato)
					FROM MinutiAlChilometro
					WHERE CodStrada = _codstrada );
	
    CASE
		WHEN ritardo = 0 THEN
			SET @Situazione = 'Traffico regolare sulla strada ';
		WHEN ritardo BETWEEN 0 AND 5 THEN
			SET @Situazione = 'Nessun rallentamento rilevato sulla strada';
		WHEN ritardo BETWEEN 6 AND 20 THEN
			SET @Situazione = 'Leggeri rallentamenti rilevati sulla strada';
		WHEN ritardo BETWEEN 21 AND 40 THEN
			SELECT 'Rallentamenti rilevati sulla strada';
		WHEN ritardo BETWEEN 41 AND 70 THEN
			SET @Situazione = 'Code rilevate sulla strada';
		WHEN ritardo > 71 THEN
			SET @Situazione = 'Traffico fermo sulla strada';
	END CASE;
    
SELECT 
    @Situazione AS SituazioneTraffico,
    _codStrada AS StradaRilevamento;
END$$

-- Aggiunta della patente a seguito della registrazione di un auto
CREATE PROCEDURE AggiungiPatente( _numero VARCHAR(30),_id VARCHAR(40), _tipo VARCHAR(20),_scadenza DATE)
BEGIN
	INSERT documento VALUES (_numero, _id, _tipo, _scadenza, 'Motorizzazione Civile'); 
END $$
		
-- Al ritiro della patente fa passare automaticamente l'utente al ruolo di fruitore
CREATE TRIGGER ritiro_patente
AFTER DELETE ON Documento FOR EACH ROW
BEGIN	
	IF (OLD.Tipologia = 'Patente b1') OR (OLD.Tipologia = 'Patente b2') OR (OLD.Tipologia = 'Patente c1') OR (OLD.Tipologia = 'Patente c2') THEN
		UPDATE Utente
        SET Stato = 'Fruitore'
        WHERE NomeUtente = OLD.NomeUtente;
	END IF;
END $$
    
-- utente fruitore che richiede una variazione all'interno di un pool
CREATE PROCEDURE RichiediVariazione(IN _idrichiedente VARCHAR(40), IN _strada INT UNSIGNED, IN _km INT, IN _codPool INT UNSIGNED)
BEGIN
	DECLARE _flessibilita ENUM ('BASSO','MEDIO','ALTO');
    DECLARE _variazioniprecedenti INT UNSIGNED DEFAULT 0;
    DECLARE _kmrichiesta INT DEFAULT 0;
    DECLARE _kmpartenza INT DEFAULT 0;
    DECLARE _stradapartenza INT UNSIGNED DEFAULT 0;
	DECLARE _kmarrivo INT UNSIGNED DEFAULT 0;
    DECLARE _stradaarrivo INT UNSIGNED DEFAULT 0;
    
    -- push della variazione
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
                                            
	SELECT 
    numChilometro, CodStrada
INTO _kmpartenza , _stradapartenza FROM
    PosizionePartenzaPool
WHERE
    CodPool = _codPool;
    
SELECT 
    numChilometro, CodStrada
INTO _kmarrivo , _stradaarrivo FROM
    PosizioneArrivoPool
WHERE
    CodPool = _codPool;
    
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
    
    -- devo vedere se è raggiungibille dalla strada in cui sono
    
	IF ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) ) THEN
    
		SET _kmrichiesta = (SELECT ABS(_km - CAST(I.kmStrada2 AS SIGNED))
							FROM Incrocio I
								INNER JOIN StradeTragittoPool STP ON STP.CodStrada = I.CodStrada1
							WHERE I.CodStrada2 = _strada);
                                
    END IF;
    
	-- in base al grado di flessibilità espresso do una risposta
    CASE
		WHEN ( (_flessibilita = 'BASSO') AND (_kmrichiesta <= 2) AND ((_stradapartenza = _strada) OR (_stradaarrivo = _strada)) ) THEN
			
			IF(_stradapartenza = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
                
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
			
           
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_flessibilita = 'MEDIA') AND (_kmrichiesta <= 4) AND ((_stradapartenza = _strada) OR (_stradaarrivo = _strada))) THEN
        
			IF(_stradapartenza = _strada) THEN

			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
			
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_flessibilita = 'ALTO') AND (_kmrichiesta <= 6) AND  ((_stradapartenza = _strada) OR (_stradaarrivo = _strada))) THEN
        
			IF(_stradapartenza = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmInizioStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
            
            ELSEIF(_stradaarrivo = _strada) THEN
            
			UPDATE StradeTragittoPool
            SET kmFineStrada = _km
            WHERE CodPool = _codPool
				AND CodStrada = _strada;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
                
			END IF;
                
		WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) AND (_flessibilita = 'BASSO') AND (_kmrichiesta <= 2) ) THEN
			
            INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
                
		WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo) AND (_flessibilita = 'MEDIO') AND (_kmrichiesta <= 4) ) THEN
			
			INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
			
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
        AND CodPool = _codPool;
		
        WHEN ( (_strada <> _stradapartenza) AND (_strada <> _stradaarrivo)  AND (_flessibilita = 'ALTO') AND (_kmrichiesta <= 6) ) THEN
            
            INSERT StradeTragittoPool
            SET CodStrada = _strada, CodPool = _codPool, kmInizioStrada = _km, kmFineStrada = _km + _kmrichiesta;
            
UPDATE Variazione 
SET 
    Stato = 'ACCETTATA'
WHERE
    IdRichiedente = _idrichiedente
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

-- sto percorrendo una nuova strada durante un noleggio
CREATE PROCEDURE nuova_strada_percorsa_noleggio(IN _codnoleggio INT, IN _strada INT, IN _km INT, IN _targa VARCHAR(7))
BEGIN
	DECLARE _password VARCHAR(128);
    
    SET _password = (SELECT U.Password_
						FROM Utente U
							INNER JOIN Auto A ON U.NomeUtente = A.Id
						WHERE A.Targa = _targa);
                        
	UPDATE TrackingNoleggio 
SET 
    Stato = 'CONCLUSO'
WHERE
    CodNoleggio = _codnoleggio;
                        
	INSERT TrackingNoleggio
    SET CodNoleggio = _codnoleggio, CodStrada = _strada, kmStrada = _km, Password_ = _password, Targa = _targa, Timestamp_ = current_timestamp();
    
END $$

 -- --------------------------------------------------------- OPERAZIONI ------------------------------------------------------------------------------------

 -- OPERAZIONE 1: REGISTRAZIONE DI UN UTENTE
DROP PROCEDURE IF EXISTS RegistraUtente $$
CREATE PROCEDURE RegistraUtente(
									IN _password VARCHAR(124), 
                                    IN _indirizzo VARCHAR(100), 
                                    IN _cognome VARCHAR(20), 
                                    IN _nome VARCHAR(20), 
                                    IN _codfiscale VARCHAR(16),
                                    IN _numdocumento VARCHAR(20),
                                    IN _tipologia VARCHAR(50),
                                    IN _scadenza DATE,
                                    IN _enterilascio VARCHAR(50),
                                    IN _numtelefono VARCHAR(10),
                                    IN _nomeutente VARCHAR(40),
                                    IN _domanda TEXT,
                                    IN _risposta TEXT
								)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
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
		INSERT INTO Utente(Password_, Ruolo, Indirizzo, Cognome, Nome, CodFiscale,NumeroTelefono, MediaVoto,DataIscrizione,NomeUtente) VALUES (SHA1(_password), 'fruitore', _indirizzo, _cognome, _nome, _codfiscale,_numtelefono, 0.0 ,current_timestamp(),_nomeutente);
        INSERT INTO Account VALUES (_nomeutente,SHA1(_password),_domanda,_risposta);
         
		
		INSERT INTO Documento(NumDocumento, NomeUtente, Tipologia, Scadenza, EnteRilascio) VALUES (_numdocumento, _nomeutente, _tipologia, _scadenza, _enterilascio);
    END IF;
 END $$

-- OPERAZIONE 2: ELIMINAZIONE DI UN UTENTE
CREATE PROCEDURE EliminazioneUtente(IN _id VARCHAR(40), IN _password VARCHAR(128))
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    DECLARE controllo VARCHAR(128);
    
    -- Verifico se l'utente esiste
    SET esiste =	(
	    			SELECT COUNT(*)
				FROM 	Utente U
				WHERE	U.NomeUtente = _id
			);
    
    SET controllo = (SELECT U.Password_
						FROM Utente U
                        WHERE U.NomeUtente = _id);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF ( (esiste = 1) AND (controllo = SHA1(_password)) ) THEN
		DELETE FROM Utente WHERE nomeUtente = _id;
		DELETE FROM Documento 
WHERE
    NomeUtente = _id;
		DELETE FROM Auto 
WHERE
    Id = _id;
		DELETE FROM Account WHERE SHA1(_password) = Password_ AND NomeUtente = _id;
	END IF;
END $$


-- OPERAZIONE 3: VISUALIZZAZIONE CARATTERISTICHE AUTO

DROP PROCEDURE IF EXISTS CaratteristicheAuto $$
CREATE PROCEDURE CaratteristicheAuto(IN _targa VARCHAR(9))
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    -- Verifico se l'auto esiste
    SET esiste =(
			SELECT COUNT(*)
			FROM 	Auto A
			WHERE	A.Targa = _targa
		);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Auto non esistente';
	ELSEIF esiste = 1 THEN
		SELECT a.targa,c.numPosti,c.velocitaMax,c.annoImmatricolazione, c.alimentazione, c.cilindrata, c.modello,c.casaProduttrice, cm.urbano AS consumoUrbano, cm.extraUrbano AS consumoExtraUrbano, cm.misto AS consumoMisto,o.peso, o.connettivita,o.tavolino,o.tettoInVetro,o.bagagliaio,o.valutazioneAuto,c.rumoreMedio, C.Comfort AS LivelloComfort
        FROM Auto a NATURAL JOIN Optional o NATURAL JOIN ConsumoMedio cm NATURAL JOIN Caratteristiche c
        WHERE a.Targa = _targa;
        
	END IF;
END $$


-- OPERAZIONE 4: REGISTRAZIONE NUOVA AUTO

DROP PROCEDURE IF EXISTS RegistrazioneAuto $$
CREATE PROCEDURE RegistrazioneAuto	(
										IN _targa VARCHAR(9),
										IN _id VARCHAR(40), 
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
                                        IN _ConsumoMedioMisto DOUBLE,
                                        IN _comfort INT
									)
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    -- Verifico se l'auto già esiste
    SET esiste =	(
						SELECT COUNT(*)
						FROM 	Auto A
						WHERE	A.Targa = _targa
					);
    
    IF esiste = 1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Auto già esistente';
	ELSEIF esiste = 0 THEN
		INSERT INTO Auto(Targa, Id) VALUES (_targa, _id);
        INSERT INTO Caratteristiche(Targa, NumPosti, VelocitaMax, AnnoImmatricolazione, Alimentazione, Cilindrata, Modello, CasaProduttrice,RumoreMedio,Comfort) VALUES (_targa, _NumPosti, _VelocitaMax, _AnnoImmatricolazione, _Alimentazione, _Cilindrata, _Modello, _CasaProduttrice,_rumoreMedio,_comfort);
        INSERT INTO StatoIniziale(Targa, KmPercorsi, QuantitaCarburante, CostoUsura) VALUES (_targa, _KmPercorsi, _QuantitaCarburante, _CostoUsura);
        INSERT INTO Optional(Targa, Peso, Connettivita, Tavolino, TettoInVetro, Bagagliaio, ValutazioneAuto) VALUES (_targa, _Peso, _Connettivita, _Tavolino, _TettoInVetro, _Bagagliaio, _ValutazioneAuto);
        INSERT INTO ConsumoMedio(Targa,Urbano,Extraurbano,Misto) VALUES (_targa, _ConsumoMedioUrbano, _ConsumoMedioExtraurbano,_ConsumoMedioMisto);
	END IF;
END $$


-- OPERAZIONE 5: VISUALIZZAZIONE VALUTAZIONE UTENTE
DROP PROCEDURE IF EXISTS ValutazioneUtente $$
CREATE PROCEDURE ValutazioneUtente(IN _id VARCHAR(40))
BEGIN
	
    DECLARE esiste INT DEFAULT 0;
    
    
    SET esiste = (
			SELECT COUNT(*)
			FROM 	Utente U
			WHERE	U.NomeUtente = _id
		 );
    
   	IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
		SELECT	U.NomeUtente AS Utente, U.MediaVoto, AVG(S.Persona) AS Persona, AVG(S.PiacereViaggio) AS PiacereDiViaggio, AVG(S.Serieta) AS Serieta, AVG(S.Comportamento) AS Comportamento
        FROM 	Utente U INNER JOIN ValutazioneUtente S ON U.NomeUtente = S.IdVotato
        WHERE 	U.NomeUtente = _id;
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
    DECLARE _targa VARCHAR(10) DEFAULT '';
    
    
    -- Dichiarazione dei cursuori
        
	DECLARE cursore CURSOR FOR
		SELECT kmInizioStrada,kmFineStrada,CodStrada
        FROM StradeTragittoPool
        WHERE CodPool = _codpool;
	
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
            
SELECT 
    S.CostoCarburante
INTO costocarbutante FROM
    Pool S
WHERE
    S.CodPool = _codpool;
           
SELECT 
    A.Targa
INTO _targa FROM
    Auto A
        INNER JOIN
    Pool P ON A.Targa = P.Targa
WHERE
    P.CodPool = _codpool;

			SELECT 
    S.CostoUsura
INTO usura FROM
    StatoIniziale S
WHERE
    S.Targa = _targa;
            
SELECT 
    CM.Urbano
INTO urbano FROM
    ConsumoMedio CM
WHERE
    CM.Targa = _targa;
            
SELECT 
    CM.ExtraUrbano
INTO extraurbano FROM
    ConsumoMedio CM
WHERE
	CM.Targa = _targa;
            
SELECT 
    CM.Misto
INTO misto FROM
    ConsumoMedio CM
WHERE
    CM.Targa = _targa;
			
            OPEN cursore;
			
            -- Ciclo
preleva : 	LOOP
				IF finito = 1 THEN
					LEAVE preleva;
				END IF;
                
                FETCH cursore INTO kminiziost,kmfinest,_codstrada;
                
                SET stradapercorsa = kmfinest - kminiziost;
                
SELECT 
    ClassificazioneTecnica
INTO tipostrada FROM
    Strada
WHERE
    CodStrada = _codstrada;
                
                CASE
					WHEN tipostrada = 'Urbana' THEN
						SET kmperstradaurbana = kmperstradaurbana + stradapercorsa;
					WHEN tipostrada = 'ExtraUrbana' OR tipostrada = 'Autostrada' THEN
						SET kmperstradaextra = kmperstradaextra + stradapercorsa;
					WHEN tipostrada = 'Misto' THEN
						SET kmperstradamista = kmperstradamista + stradapercorsa;                        
                END CASE;
            END LOOP preleva;
            
            CLOSE cursore;
            
SET 
    @CostoOperativo = numKm * usura;
            
SET 
    @ConsumoCarburante = (kmperstradaurbana / urbano) + (kmperstradaextra / extraurbano) + (kmperstradamista / misto);
            
            
SET @tot = (kmperstradaurbana/urbano)*costocarbutante + (kmperstradaextra/extraurbano)*costocarbutante + (kmperstradamista/misto)*costocarbutante + numKm*usura;
            
            UPDATE Pool
            SET Prezzo = @tot
            WHERE CodPool = _codPool;
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
    DECLARE finale DOUBLE DEFAULT 0;
    
    
    -- Dichiarazione dei cursuori
    
    DECLARE cursore CURSOR FOR
		SELECT	kmInizioStrada,kmFineStrada,CodStrada
		FROM	StradeTragittoSharing
        WHERE	CodSharing = _codsharing;
    -- Dichiarazione Handler
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1; 
        
    -- Verifico se lo sharing già esiste
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
            
SELECT 
    S.CostoCarburante
INTO costocarburante FROM
    RideSharing S
WHERE
    S.CodSharing = _codsharing;
            
			SELECT 
    S.CostoUsura
INTO usura FROM
    StatoIniziale S
        INNER JOIN
    RideSharing RS ON S.Targa = RS.Targa
WHERE
    RS.CodSharing = _codsharing;
            
SELECT 
    C.Urbano
INTO urbano FROM
    ConsumoMedio C
        INNER JOIN
    RideSharing RS ON C.Targa = RS.Targa
WHERE
    RS.CodSharing = _codsharing;
            
SELECT 
    C.ExtraUrbano
INTO extraurbano FROM
    ConsumoMedio C
        INNER JOIN
    RideSharing RS ON C.Targa = RS.Targa
WHERE
    RS.CodSharing = _codsharing;
            
SELECT 
    C.Misto
INTO misto FROM
    ConsumoMedio C
        INNER JOIN
    RideSharing RS ON C.Targa = RS.Targa
WHERE
    RS.CodSharing = _codsharing;
			
            OPEN cursore;
			
            -- Ciclo
preleva : 	LOOP
				IF finito = 1 THEN
					LEAVE preleva;
				END IF;
                
                FETCH cursore INTO kminiziost,kmfinest,_codstrada;
                SET stradapercorsa = kmfinest - kminiziost;
                
SELECT 
    ClassificazioneTecnica
INTO tipostrada FROM
    Strada
WHERE
    CodStrada = _codstrada;
                
                CASE
					WHEN tipostrada = 'Urbana' THEN
						SET kmperstradaurbana = kmperstradaurbana + stradapercorsa;
					WHEN tipostrada = 'ExtraUrbana' OR tipostrada = 'Autostrada' THEN
						SET kmperstradaextra = kmperstradaextra + stradapercorsa;
					WHEN tipostrada = 'Misto' THEN
						SET kmperstradamista = kmperstradamista + stradapercorsa;                        
                END CASE;
            END LOOP preleva;
            
            CLOSE cursore;
            
SET finale = numKm * usura + (kmperstradaurbana / urbano) + (kmperstradaextra / extraurbano) + (kmperstradamista / misto);
            
UPDATE RideSharing 
SET 
    Prezzo = finale + 0.05*finale -- tassa per la risposta
WHERE
    CodSharing = _codSharing;
            
		END;
	END IF;
END $$

-- OPERAZIONE 7: VISUALIZZAZIONE AFFIDABILITA' UTENTE
DROP PROCEDURE IF EXISTS AffidabilitaUtente $$
CREATE PROCEDURE AffidabilitaUtente(IN _id VARCHAR(40))
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
						WHERE	U.NomeUtente = _id
					);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
		
        SELECT 	U.MediaVoto INTO mediavoto
		FROM	Utente U
		WHERE	U.NomeUtente = _id;
        
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
                WHERE U.NomeUtente = _id;
			WHEN (Affidabilita BETWEEN 40 AND 70) THEN 
				UPDATE Utente U
				SET U.Affidabilita = 'MEDIA'
                WHERE U.NomeUtente = _id;
			WHEN (Affidabilita >= 70) THEN 
				UPDATE Utente U
				SET U.Affidabilita = 'ALTA'
                WHERE U.NomeUtente = _id;
			END CASE;

   
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
                            
	SET postirimanenti = postidisponibili - postioccupati;
    
	SELECT _codpool AS Pool, postioccupati, postidisponibili, postirimanenti;
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
    
SELECT _codsharing as Sharing, postioccupati, postidisponibili, postirimanenti;
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
						WHERE	U.NomeUtente = _id
					);
    
    IF esiste = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. Utente non esistente';
	ELSEIF esiste = 1 THEN
	SET N =	(
				SELECT	COUNT(*)
				FROM 	RideSharing RS
					INNER JOIN Auto A ON RS.Targa = A.Targa
                WHERE	A.Id = _id
			)
            +
            (
				SELECT	COUNT(*)
				FROM 	Pool P
					INNER JOIN Auto A ON P.Targa = A.Targa
                WHERE A.Id = _id
            );
            
SELECT  _id as Utente, n AS NumeroServiziErogati;
    END IF;
END $$



-- OPERAZIONE 10: Inserimento valutazione utente

DROP PROCEDURE IF EXISTS InserisciValutazioneUtente $$
CREATE PROCEDURE InserisciValutazioneUtente(IN id_votante VARCHAR(40), 
											IN id_votato VARCHAR(40), 
                                            IN recensione VARCHAR(200), 
                                            IN persona_ DOUBLE,
                                            IN piacere_viaggio DOUBLE, 
                                            IN serieta_ DOUBLE,
                                            IN comportamento_ DOUBLE)
BEGIN
	INSERT INTO ValutazioneUtente (IdVotante, IdVotato, Recensione, Persona, PiacereViaggio, Serieta, Comportamento) 
    VALUES (id_votante, id_votato, recensione, persona_, piacere_viaggio, serieta_, comportamento_);
    
END $$
	
DELIMITER ;
 

/*INSERT*/-- ------------------------------------------------------------------------------------------

-- UTENTE 
CALL RegistraUtente('root' , 'Largo Catallo 11', 'Marino', 'Gabriele','PGGLRD98E28C309F','AX96439','Carta di identità','2023-03-01','Comune','3334409765','Gab98','Colore degli occhi di mia madre?','Verdi');
CALL RegistraUtente('root' , 'Via Strada di Salci 46', 'Poggiani', 'Leonardo','MRNGBR98H12X107D','AE162249','Carta di identità','2023-03-01','Comune','3456543123','Poggio98','Primo animale domestico?','Gatto');
CALL RegistraUtente('root' , 'Via Roma 11',  'Tonioni','Francesca','TNNFSC98Z12C103K','AC54321','Carta di identità','2023-03-01','Comune','3289845678','TonyOni','Numero civico casa della nonna?','34');
CALL RegistraUtente('root' , 'Via Napoli 45', 'Scebba', 'Andrea Angelo','SCBANG48Z12S404Q','AW92812','Carta di identità','2023-03-01','Comune','3897654321','AndreSceb','Film preferito?','Pirati dei Caraibi 3');
CALL RegistraUtente('root' , 'Via Ponticelli 12',  'Chiodi','Salvatore','SLVCDH98E28C309F','AM12652','Carta di identità','2021-10-21','Comune','3214356789','Salvo89','Colore preferito?','Arancione');
CALL RegistraUtente('root' , 'Via Toniolo 33',  'Randazzo','Matteo','MTTRZZ38E28C309F','AA12652','Carta di identità','2023-10-01','Comune','3456789123','Randy','Città natale?', 'Berlino');
CALL RegistraUtente('root' , 'Lungarno Mediceo 29','Togliatti', 'Palmiro', 'PCDLNG47E21C102F','AC12652','Carta di identità','2021-10-21','Comune','3456543123','Palm21','Colore prima auto?','Nero');
CALL RegistraUtente('root' , 'Via Giordano Bruno 31','Scattino', 'Dania', 'SCCDNA68E18C208F','AM12439','Carta di identità','2023-03-01','Comune','3467898654','daniascattino','Nome del primo gatto?','Gigia');
CALL RegistraUtente('root' , 'Via del Pero 200', 'Poggiani','Claudio', 'PGGCLD63H12X437D','GR6335015A','Patente B1','2023-03-01','Motorizzazione Civile','3421234567','ClaPogg','Nome di tua madre?','Elena');
CALL RegistraUtente('root' , 'Lungarno Mediceo 11','Buricca', 'Luciana', 'BRCLCN43Z12C403G','LR9315015F','Patente C1','2023-03-01','Motorizzazione Civile','3678956432','LucyInTheSky','Nome del primo fidanzato?','Vincenzo');

CALL AggiungiPatente('HG2314915L', 'AndreSceb', 'Patente B1', '2019-05-10');
CALL AggiungiPatente('KJ2337815W', 'daniascattino', 'Patente C1', '2020-05-12');
CALL AggiungiPatente('HG2314915L', 'LucyInTheSky', 'Patente B2', '2023-04-17');
CALL AggiungiPatente('YT7315115P', 'Poggio98', 'Patente B1', '2019-05-10');

-- AUTO
CALL RegistrazioneAuto('AE987CB','AndreSceb','4','200','2010','Gasolio','2000','Panamera','Porsche','10000','10','0.3','4000', '1', '0', '0', '20', '12000', '24','12.4','17.2','18.5','4');
CALL RegistrazioneAuto('AW123OB','daniascattino','4','200','2010','Benzina','1500','Focus','Ford','5000','30','0.08','10000', '1', '0', '1', '30', '2000', '10','18.9','14.3','8.4','3');
CALL RegistrazioneAuto('BC100RT','LucyInTheSky','2','180','2016','Elettrica','1200','Corsa','Opel','0','2','0.09','5000', '1', '1', '0', '10', '1000', '24','8.4','11.2','16.5','2');
CALL RegistrazioneAuto('NC122PU','Poggio98','5','200','2018','GPL','1800','Megan','Ford','1000','5','0.2','10000', '1', '0', '0', '20', '20000', '40','22.9','19.3','20.4','5');
CALL RegistrazioneAuto('AM107XB','ClaPogg','8','180','2002','Metano','800','Veyron','Bugatti','0','10','0.1','8000', '0', '0', '0', '10', '10000', '20','10.4','13.2','17.5','4');

-- STRADA
INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '100');
INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '100');
INSERT INTO `progetto`.`incrocio` (`CodStrada1`, `CodStrada2`, `kmStrada1`, `kmStrada2`) VALUES ('1', '2', '20', '20');
INSERT INTO `progetto`.`incrocio` (`CodStrada1`, `CodStrada2`, `kmStrada1`, `kmStrada2`) VALUES ('1', '2', '55', '55');

-- PER POOL 
INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '100');
INSERT INTO `progetto`.`incrocio` (`CodStrada1`, `CodStrada2`, `kmStrada1`, `kmStrada2`) VALUES ('1', '2', '6', '3');
INSERT INTO `progetto`.`incrocio` (`CodStrada1`, `CodStrada2`, `kmStrada1`, `kmStrada2`) VALUES ('1', '3', '4', '4');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '100', '0', '3');

INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '100');
INSERT INTO `progetto`.`incrocio` (`CodStrada1`, `CodStrada2`, `kmStrada1`, `kmStrada2`) VALUES ('1', '4', '5', '3');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '40', '0', '4');

INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'ExtraUrbana', '200');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('90', '100', '0', '5');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '150', '101', '5');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('30', '200', '151', '5');

INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '300');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('30', '150', '0', '6');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('70', '300', '151', '6');

INSERT INTO Strada(Tipologia, ClassificazioneTecnica, Lunghezza) VALUES ('statale', 'Urbana', '50');
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '50', '0', '7');

-- CORSIE DI IMMISSIONE
INSERT INTO CorsieDiImmissione(CodStrada1, CodStrada2, kmStrada1, kmStrada2) VALUES ('1', '2', '10', '20');
-- LIMITI DI VELOCITA'
INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '20', '0', '1');

INSERT INTO `progetto`.`limitidivelocita` ( `ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ( '70', '50', '20', '1');

INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`,`kmInizio`, `CodStrada`) VALUES ('30', '40','0', '2');

INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '100', '40', '2');

INSERT INTO `progetto`.`limitidivelocita` (`ValoreLimite`, `kmFine`, `kmInizio`, `CodStrada`) VALUES ('50', '100', '50','1');

-- CAR SHARING
INSERT INTO PrenotazioneDiNoleggio (DataInizio, DataFine, idFruitore, Targa, Prezzo) VALUES ('2019-01-12 20:00:00', '2019-01-15 21:00:00', 'ClaPogg', 'AE987CB','200');

-- VALUTAZIONE FRUITORE NOLEGGIO
CALL InserisciValutazioneUtente('AndreSceb', 'ClaPogg', 'Persona gentilissima, macchina stupenda e confortevole', '4', '4', '4', '5');


-- VALUTAZIONE PROPONENTE NOLEGGIO
CALL InserisciValutazioneUtente('ClaPogg', 'AndreSceb', 'Ha lasciato la mia auto sporca e con la puzza di fumo, pessimo', '2', '1', '1', '2');


-- TRAGITTO NOLEGGIO
INSERT INTO TragittoNoleggio(CodNoleggio, kmPercorsi) VALUES ('1','20');
-- POSIZIONE NOLEGGIO
INSERT INTO PosizioneArrivoNoleggio VALUES ('1','1','10');
INSERT INTO PosizionePartenzaNoleggio VALUES ('1','1', '1');

CALL nuova_strada_percorsa_noleggio(1,2,5,'AE987CB');

-- SINISTR0 NOLEGGIO
INSERT INTO `progetto`.`sinistronoleggio` ( `TargaVeicoloProponente`,`IdGuidatore`, `Orario`, `CodStrada`, `KmStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AE987CB','ClaPogg', '2018-01-10 10:30:00', '1', '5', 'Na botta assurda', '55');
INSERT INTO `progetto`.`sinistronoleggio` ( `TargaVeicoloProponente`,`IdGuidatore`, `Orario`, `CodStrada`, `KmStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AE987CB','ClaPogg', '2018-01-14 10:35:00', '1', '5', 'Na botta assurda', '10');

-- POOL
INSERT INTO `progetto`.`pool` (`GiornoPartenza`, `Targa`, `GradoFlessibilita`) VALUES ('2019-02-26 11:00:00', 'AW123OB', 'ALTO');
INSERT INTO `progetto`.`stradetragittopool` (`CodStrada`, `CodPool`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '1', '0', '10');
INSERT INTO `progetto`.`stradetragittopool` (`CodStrada`, `CodPool`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '1', '0', '10');

INSERT INTO `progetto`.`posizionepartenzapool` (`CodPool`, `CodStrada`, `numChilometro`) VALUES ('1', '1', '2');
INSERT INTO `progetto`.`posizionearrivopool` (`CodPool`, `CodStrada`, `numChilometro`) VALUES ('1', '2', '10');

INSERT INTO `progetto`.`adesionipool` (`CodPool`, `IdFruitore`) VALUES ('1','ClaPogg');
INSERT INTO `progetto`.`adesionipool` (`CodPool` ,`IdFruitore`) VALUES ('1','Gab98');
INSERT INTO `progetto`.`adesionipool` (`CodPool`, `IdFruitore`) VALUES ('1', 'Palm21');

-- SINISTRO POOL
INSERT INTO `progetto`.`sinistropool` (`TargaVeicoloProponente`, `Orario`, `KmStrada`, `CodStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AW123OB', '2018-11-18 14:45:00', '3', '1', 'Addosso a un palo', '80');

CALL RichiediVariazione('Gab98',3,2,1);
CALL RichiediVariazione('ClaPogg',4,10,1);
CALL RichiediVariazione('Palm21',4,2,1);
CALL RichiediVariazione('ClaPogg',2,10,1);
CALL RichiediVariazione('Gab98',1,40,1);


CALL CalcoloOrarioStimatoPool(1,@tempo4);

-- RIDE SHARING
INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('ClaPogg', '2019-1-6 11:00:00', 'AE987CB');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '1', '0', '30');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '1', '0', '30');

-- sharing 1
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', 'Gab98');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', 'LucyInTheSky');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', 'Palm21');

CALL InserisciValutazioneUtente('AndreSceb', 'ClaPogg', 'Responsabile e prudente alla guida', '3', '3', '3', '3');
CALL InserisciValutazioneUtente('AndreSceb', 'Gab98', 'Scorbutico, non ha mai aperto bocca', '2', '2', '1', '3');
CALL InserisciValutazioneUtente('AndreSceb', 'LucyInTheSky', 'Viaggio piacevole', '3', '4', '3', '3');
CALL InserisciValutazioneUtente('AndreSceb', 'Palm21', 'Macchina confortevole e viaggio veloce', '4', '4', '5', '3');


CALL InserisciValutazioneUtente('ClaPogg', 'AndreSceb', 'Bravissima persona', '4', '4', '4', '4');
CALL InserisciValutazioneUtente('Gab98', 'AndreSceb', 'Una piacevole compagnia per tutto il viaggio', '4', '3', '4', '2');
CALL InserisciValutazioneUtente('LucyInTheSky', 'AndreSceb', 'Un cafone, non gli darò mai più un passaggio', '1', '1', '1', '2');
CALL InserisciValutazioneUtente('Palm21', 'AndreSceb', 'Piacevole viaggio anche se poco socievole', '1', '4', '3', '5');


-- RIDE SHARING
INSERT INTO TragittoSharing VALUES ('1','1','60');

-- POSIZIONE SHARING
INSERT INTO PosizionePartenzaSharing VALUES ('1','1', '0');
INSERT INTO PosizioneArrivoSharing VALUES ('1','2', '30');

CALL CalcoloOrarioStimatoSharing(1, @tempo1);


INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('Gab98', '2019-1-6 11:00:00', 'NC122PU');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '2', '10', '60');

-- sharing 2
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', 'daniascattino');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', 'Randy');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', 'AndreSceb');

CALL InserisciValutazioneUtente('Poggio98', 'AndreSceb', 'Bene, ottima guida', '3', '3', '3', '3');
CALL InserisciValutazioneUtente('Poggio98', 'Randy', 'Bravo guidatore e brava persona', '2', '3', '1', '3');
CALL InserisciValutazioneUtente('Poggio98', 'Gab98', 'Malissimo, non sa guidare minimanente', '1', '1', '2', '2');
CALL InserisciValutazioneUtente('Poggio98', 'daniascattino', 'Non ci siamo, macchina piena di mozziconi di sigaretta', '4', '4', '5', '3');

CALL InserisciValutazioneUtente('AndreSceb', 'Poggio98', 'Bravissima persona', '4', '4', '4', '4');
CALL InserisciValutazioneUtente('Randy', 'Poggio98', 'Soddisfacente viaggio', '2', '3', '4', '2');
CALL InserisciValutazioneUtente('Gab98', 'Poggio98', 'Un maleducato e incivile', '1', '4', '3', '5');
CALL InserisciValutazioneUtente('daniascattino', 'Poggio98', 'Piacevole viaggio con un mio nuovo amico', '1', '4', '3', '5');


INSERT INTO TragittoSharing  VALUES ('2','2','50');

INSERT INTO PosizionePartenzaSharing VALUES ('2','2', '10');
INSERT INTO PosizioneArrivoSharing VALUES ('2','2', '60');

CALL CalcoloOrarioStimatoSharing(2, @tempo2);

INSERT INTO `progetto`.`ridesharing` ( `IdFruitore`, `OraPartenza`, `Targa`) VALUES ('Salvo89', '2019-1-6 11:00:00', 'BC100RT');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '3', '50', '80');


-- sharing 3 
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('3', 'daniascattino');
CALL InserisciValutazioneUtente('Salvo89', 'LucyInTheSky', 'Un pericolo alla guida', '2', '2', '2', '1');
CALL InserisciValutazioneUtente('daniascattino', 'LucyInTheSky', 'Persona poco educata', '2', '3', '1', '3');


CALL InserisciValutazioneUtente('LucyInTheSky', 'Salvo89', 'Bravissima persona, la richiamerò', '4', '4', '4', '4');
CALL InserisciValutazioneUtente('LucyInTheSky', 'daniascattino', 'Non so perchè avesse paura di me', '2', '3', '4', '5');

INSERT INTO TragittoSharing  VALUES ('3','3','30');

INSERT INTO PosizionePartenzaSharing VALUES ('3','2', '50');
INSERT INTO PosizioneArrivoSharing VALUES ('3','2', '80');

CALL CalcoloOrarioStimatoSharing(3, @tempo3);

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('2', '80', '1', '10', 'Gab98',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('2', '40', '1', '0', 'daniascattino',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '1', '10', 'ClaPogg',current_timestamp());

CALL AffidabilitaUtente('AndreSceb');
CALL AffidabilitaUtente('ClaPogg');
CALL AffidabilitaUtente('daniascattino');
CALL AffidabilitaUtente('Gab98');
CALL AffidabilitaUtente('LucyInTheSky');
CALL AffidabilitaUtente('Palm21');
CALL AffidabilitaUtente('Poggio98');
CALL AffidabilitaUtente('Randy');
CALL AffidabilitaUtente('Salvo89');
CALL AffidabilitaUtente('TonyOni');

CALL ValutazioneUtente('AndreSceb');
CALL ValutazioneUtente('ClaPogg');
CALL ValutazioneUtente('daniascattino');
CALL ValutazioneUtente('Gab98');
CALL ValutazioneUtente('LucyInTheSky');
CALL ValutazioneUtente('Palm21');
CALL ValutazioneUtente('Poggio98');
CALL ValutazioneUtente('Randy');
CALL ValutazioneUtente('Salvo89');

CALL CostoPool(1);

CALL NumeroPostiRimanentiSharing(1);

CALL EliminazioneUtente('Randy','root');

INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('Palm21', '2019-1-6 15:00:00', 'AM107XB');

INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '4', '0', '30');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '4', '0', '30');

-- sharing 4
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', 'ClaPogg');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', 'Gab98');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', 'Poggio98');


CALL InserisciValutazioneUtente('Salvo89', 'Palm21', 'Bene', '3', '3', '3', '3');
CALL InserisciValutazioneUtente('Salvo89', 'Gab98', 'Bravo', '2', '3', '1', '3');
CALL InserisciValutazioneUtente('Salvo89', 'ClaPogg', 'Malissimo', '1', '1', '2', '2');
CALL InserisciValutazioneUtente('Salvo89', 'Poggio98', 'Non ci siamo', '4', '4', '5', '3');


CALL InserisciValutazioneUtente('Palm21', 'Salvo89', 'Bravissima persona', '4', '4', '4', '4');
CALL InserisciValutazioneUtente('ClaPogg', 'Salvo89', 'Soddisfacente', '2', '3', '4', '2');
CALL InserisciValutazioneUtente('Poggio98', 'Salvo89', 'Un cafone', '1', '4', '3', '5');
CALL InserisciValutazioneUtente('Gab98', 'Salvo89', 'Piacevole viaggio', '1', '4', '3', '5');


-- RIDE SHARING
INSERT INTO TragittoSharing VALUES ('4','4','60');

-- POSIZIONE SHARING
INSERT INTO PosizionePartenzaSharing VALUES ('4','1', '0');
INSERT INTO PosizioneArrivoSharing VALUES ('4','2', '30');


CALL CalcoloOrarioStimatoSharing(4, @tempo4);

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('3', '4', '2', '10', 'Gab98',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '30', '1', '10', 'daniascattino',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '3', '4', 'ClaPogg',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('4', '50', '2', '10', 'LucyInTheSky',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('4', '40', '2', '0', 'Palm21',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '1', '30', 'Poggio98',current_timestamp());

CALL NumeroServiziErogati('Poggio98');
CALL NumeroServiziErogati('ClaPogg');

CALL NumeroPostiRimanentiSharing(3);
CALL NumeroPostiRimanentiSharing(4);

CALL CaratteristicheAuto('BC100RT');
CALL CaratteristicheAuto('AW123OB');

CALL CalcolaCodaSharing(1);
CALL CalcolaCodaSharing(2);
CALL CalcolaCodaSharing(3);
CALL CalcolaCodaSharing(4);

CALL CalcolaCodaPool(1);

CALL CostoSharing(1);
CALL CostoSharing(2);
CALL CostoSharing(3);
CALL CostoSharing(4);

CALL Ranking();

CALL info_traffico(1);
CALL info_traffico(2);

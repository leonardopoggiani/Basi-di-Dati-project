-- UTENTE 
CALL RegistraUtente('root' , 'Largo Catallo 11', 'Marino', 'Gabriele','PGGLRD98E28C309F','AX96439','Carta di identità','2023-03-01','Comune');
CALL RegistraUtente('root' , 'Via Strada di Salci 46', 'Poggiani', 'Leonardo','MRNGBR98H12X107D','AE162249','Carta di identità','2023-03-01','Comune');
CALL RegistraUtente('root' , 'Via Roma 11', 'Francesca', 'Tonioni','TNNFSC98Z12C103K','AC54321','Carta di identità','2023-03-01','Comune');
CALL RegistraUtente('root' , 'Via Napoli 45', 'Andrea Angelo', 'Scebba','SCBANG48Z12S404Q','AW92812','Carta di identità','2023-03-01','Comune');
CALL RegistraUtente('pippo' , 'Via Ponticelli 12', 'Salvatore', 'Chiodi','SLVCDH98E28C309F','AM12652','Carta di identità','2021-10-21','Comune');
CALL RegistraUtente('pluto' , 'Via Toniolo 33', 'Matteo', 'Randazzo','MTTRZZ38E28C309F','AA12652','Carta di identità','2023-10-01','Comune');
CALL RegistraUtente('paperino' , 'Lungarno Mediceo 29', 'Placido', 'Longo','PCDLNG47E21C102F','AC12652','Carta di identità','2021-10-21','Comune');
CALL RegistraUtente('pass' , 'Via Giordano Bruno 31', 'Dania', 'Scattino','SCCDNA68E18C208F','AM12439','Carta di identità','2023-03-01','Comune');
CALL RegistraUtente('pass' , 'Via del Pero 200', 'Claudio', 'Poggiani','PGGCLD63H12X437D','GR6335015A','Patente B1','2023-03-01','Motorizzazione Civile');
CALL RegistraUtente('pass' , 'Lungarno Mediceo 11', 'Luciana', 'Buricca','BRCLCN43Z12C403G','LR9315015F','Patente C1','2023-03-01','Motorizzazione Civile');

-- AUTO
CALL RegistrazioneAuto('AE987CB','1','4','200','2010','Gasolio','2000','Panamera','Porsche','10000','10','0.3','4000', '1', '0', '0', '20', '12000', '24','12.4','17.2','18.5');
CALL RegistrazioneAuto('AW123OB','3','4','200','2010','Benzina','1500','Focus','Ford','5000','30','0.08','10000', '1', '0', '1', '30', '2000', '10','18.9','14.3','8.4');
CALL RegistrazioneAuto('BC100RT','5','2','180','2016','Elettrica','1200','Corsa','Opel','0','2','0.09','5000', '1', '1', '0', '10', '1000', '24','8.4','11.2','16.5');
CALL RegistrazioneAuto('NC122PU','7','5','200','2018','Gas','1800','Megan','Ford','1000','5','0.2','10000', '1', '0', '0', '20', '20000', '40','22.9','19.3','20.4');
CALL RegistrazioneAuto('AM107XB','9','8','180','2002','Metano','800','Veyron','Bugatti','0','10','0.1','8000', '0', '0', '0', '10', '10000', '20','10.4','13.2','17.5');

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
INSERT INTO PrenotazioneDiNoleggio (DataInizio, DataFine, idFruitore, Targa, Prezzo) VALUES ('2019-01-28 20:00:00', '2019-01-30 21:00:00', '2', 'AE987CB','200');

-- VALUTAZIONE FRUITORE NOLEGGIO
INSERT INTO `progetto`.`valutazionefruitorenoleggio` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '2', 'Insomma');

-- STELLE FRUITORE NOLEGGIO
INSERT INTO `progetto`.`stellefruitorenoleggio` (`CodVoto`, `Id`, `Persona`, `PiacereViaggio`, `Comportamento`, `Serieta`) VALUES ('1', '1', '3', '2', '4', '5');

-- VALUTAZIONE PROPONENTE NOLEGGIO
INSERT INTO `progetto`.`valutazioneproponentenoleggio` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '2', 'Molto bene');

-- STELLE PROPONENTE NOLEGGIO
INSERT INTO `progetto`.`stelleproponentenoleggio` (`CodVoto`, `Id`, `Persona`, `PiacereViaggio`, `Comportamento`, `Serieta`) VALUES ('1', '2', '2', '4', '5', '2');

-- TRAGITTO NOLEGGIO
INSERT INTO TragittoNoleggio(CodNoleggio, kmPercorsi) VALUES ('1','20');
-- POSIZIONE NOLEGGIO
INSERT INTO PosizioneArrivoNoleggio VALUES ('1','1','10');
INSERT INTO PosizionePartenzaNoleggio VALUES ('1','1', '1');

CALL nuova_strada_percorsa_noleggio(1,2,5,'AE987CB');

-- SINISTR0 NOLEGGIO
INSERT INTO `progetto`.`sinistronoleggio` ( `TargaVeicoloProponente`,`IdGuidatore`, `Orario`, `CodStrada`, `KmStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AE987CB','2', '2018-01-10 10:30:00', '1', '5', 'Na botta assurda', '55');
INSERT INTO GeneralitaSinistroNoleggio VALUES ('AE162249', 'PGGLRD98E28C309F', 'Poggiani', 'Leonardo','Via Strada di Salci 46', '345344660');
INSERT INTO `progetto`.`sinistronoleggio` ( `TargaVeicoloProponente`,`IdGuidatore`, `Orario`, `CodStrada`, `KmStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AE987CB','2', '2018-01-14 10:35:00', '1', '5', 'Na botta assurda', '10');

-- POOL
INSERT INTO `progetto`.`pool` (`GiornoPartenza`, `Targa`, `GradoFlessibilita`) VALUES ('2019-02-15 15:00:00', 'AW123OB', 'ALTO');
INSERT INTO `progetto`.`stradetragittopool` (`CodStrada`, `CodPool`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '1', '0', '10');
INSERT INTO `progetto`.`stradetragittopool` (`CodStrada`, `CodPool`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '1', '0', '10');

INSERT INTO `progetto`.`posizionepartenzapool` (`CodPool`, `CodStrada`, `numChilometro`) VALUES ('1', '1', '2');
INSERT INTO `progetto`.`posizionearrivopool` (`CodPool`, `CodStrada`, `numChilometro`) VALUES ('1', '2', '10');

INSERT INTO `progetto`.`adesionipool` (`CodPool`, `IdFruitore`) VALUES ('1','2');
INSERT INTO `progetto`.`adesionipool` (`CodPool` ,`IdFruitore`) VALUES ('1','4');
INSERT INTO `progetto`.`adesionipool` (`CodPool`, `IdFruitore`) VALUES ('1', '3');

-- SINISTRO POOL
INSERT INTO `progetto`.`sinistropool` (`TargaVeicoloProponente`, `Orario`, `KmStrada`, `CodStrada`, `Dinamica`, `PercentualeDiResponsabilita`) VALUES ('AW123OB', '2018-11-18 14:45:00', '3', '1', 'Addosso a un palo', '80');
INSERT INTO `progetto`.`generalitasinistropool` (`NumDocumento`, `CodFiscale`, `Cognome`, `Nome`, `Indirizzo`, `NumTelefono`) VALUES ('AC54321', 'ANRR6EWRERE9203', 'Tonioni', 'Francesca', 'Via Roma 11', '344405678');

CALL RichiediVariazione(1,3,2,1);
CALL RichiediVariazione(2,4,10,1);
CALL RichiediVariazione(3,4,2,1);
CALL RichiediVariazione(1,2,10,1);
CALL RichiediVariazione(4,1,40,1);


CALL CalcoloOrarioStimatoPool(1,@tempo4);

-- RIDE SHARING
INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('2', '2019-1-6 11:00:00', 'AE987CB');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '1', '0', '30');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '1', '0', '30');


INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '2', 'Bene');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '4', 'Bravo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '5', 'Malissimo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '6', 'Non ci siamo');

INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('1','2', '3', '3', '3', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('2','4', '2', '5', '1', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('3','5', '1', '1', '2', '2');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('4','6', '4', '4', '5', '3');

INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '2', 'Bravissima persona');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '4', 'Soddisfacente');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '5', 'Un cafone');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('1', '6', 'Piacevole viaggio');

INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('1','1', '4', '4', '4', '4');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('2','1', '2', '3', '4', '2');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('3','1', '1', '4', '3', '5');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('4','1', '1', '4', '3', '5');


-- RIDE SHARING
INSERT INTO TragittoSharing VALUES ('1','1','60');

-- POSIZIONE SHARING
INSERT INTO PosizionePartenzaSharing VALUES ('1','1', '0');
INSERT INTO PosizioneArrivoSharing VALUES ('1','2', '30');

CALL CalcoloOrarioStimatoSharing(1, @tempo1);


INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('4', '2019-1-6 11:00:00', 'AW123OB');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '2', '10', '60');

INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '1', 'Bene');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '7', 'Bravo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '4', 'Malissimo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '3', 'Non ci siamo');

INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('5','1', '3', '3', '3', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('6','7', '2', '3', '1', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('7','4', '1', '1', '2', '2');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('8','3', '4', '4', '5', '3');

INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '1', 'Bravissima persona');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '7', 'Soddisfacente');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '4', 'Un cafone');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('3', '3', 'Piacevole viaggio');

INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('5','3', '4', '4', '4', '4');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('6','3', '2', '3', '4', '2');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('7','3', '1', '4', '3', '5');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('8','3', '1', '4', '3', '5');

INSERT INTO TragittoSharing  VALUES ('2','2','50');

INSERT INTO PosizionePartenzaSharing VALUES ('2','2', '10');
INSERT INTO PosizioneArrivoSharing VALUES ('2','2', '60');

CALL CalcoloOrarioStimatoSharing(2, @tempo2);

INSERT INTO `progetto`.`ridesharing` ( `IdFruitore`, `OraPartenza`, `Targa`) VALUES ('7', '2019-1-6 11:00:00', 'BC100RT');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '3', '50', '80');

INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '1', 'Bene');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '2', 'Bravo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '8', 'Malissimo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '7', 'Non ci siamo');

INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('9','1', '3', '3', '3', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('10','7', '2', '3', '1', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('11','4', '1', '1', '2', '2');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('12','3', '4', '4', '5', '3');

INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '1', 'Bravissima persona');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '2', 'Soddisfacente');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '8', 'Un cafone');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '7', 'Piacevole viaggio');

INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('9','3', '4', '4', '4', '4');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('10','3', '2', '3', '4', '2');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('11','3', '1', '4', '3', '5');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('12','3', '1', '4', '3', '5');

INSERT INTO TragittoSharing  VALUES ('3','3','30');

INSERT INTO PosizionePartenzaSharing VALUES ('3','2', '50');
INSERT INTO PosizioneArrivoSharing VALUES ('3','2', '80');

CALL CalcoloOrarioStimatoSharing(3, @tempo3);

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('2', '80', '1', '10', '4',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('2', '40', '1', '0', '3',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '1', '10', '2',current_timestamp());

-- sharing 1
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', '1');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', '5');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('2', '6');

-- sharing 2
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', '4');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', '5');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('1', '6');

-- sharing 3 
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('3', '4');

CALL AffidabilitaUtente(1);
CALL AffidabilitaUtente(2);
CALL AffidabilitaUtente(3);
CALL AffidabilitaUtente(4);
CALL AffidabilitaUtente(5);
CALL AffidabilitaUtente(6);
CALL AffidabilitaUtente(7);
CALL AffidabilitaUtente(8);
CALL AffidabilitaUtente(9);
CALL AffidabilitaUtente(10);

CALL ValutazioneUtente(1);
CALL ValutazioneUtente(2);
CALL ValutazioneUtente(3);
CALL ValutazioneUtente(4);
CALL ValutazioneUtente(5);
CALL ValutazioneUtente(6);
CALL ValutazioneUtente(7);
CALL ValutazioneUtente(8);
CALL ValutazioneUtente(9);
CALL ValutazioneUtente(10);


CALL CostoPool(1);

CALL NumeroPostiRimanentiSharing(1);
CALL NumeroPostiRimanentiSharing(2);
CALL NumeroPostiRimanentiSharing(3);
CALL NumeroPostiRimanentiSharing(4);

CALL EliminazioneUtente(7,'root');


CALL Classifica();

INSERT INTO `progetto`.`ridesharing` (`IdFruitore`, `OraPartenza`, `Targa`) VALUES ('6', '2019-1-6 15:00:00', 'AM107XB');

INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('1', '4', '0', '30');
INSERT INTO `progetto`.`stradetragittosharing` (`CodStrada`, `CodSharing`, `kmInizioStrada`, `kmFineStrada`) VALUES ('2', '4', '0', '30');

INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('9', '3', 'Bene');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('9', '4', 'Bravo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('9', '9', 'Malissimo');
INSERT INTO `progetto`.`valutazionefruitoreridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('9', '5', 'Non ci siamo');

INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('13','3', '3', '3', '3', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('14','4', '2', '3', '1', '3');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('15','9', '1', '1', '2', '2');
INSERT INTO `progetto`.`stellefruitoreridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('16','5', '4', '4', '5', '3');

INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '1', 'Bravissima persona');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '2', 'Soddisfacente');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '8', 'Un cafone');
INSERT INTO `progetto`.`valutazioneproponenteridesharing` (`IdProponente`, `IdFruitore`, `Recensione`) VALUES ('5', '7', 'Piacevole viaggio');

INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('13','3', '4', '4', '4', '4');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('14','3', '2', '3', '4', '2');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('15','3', '1', '4', '3', '5');
INSERT INTO `progetto`.`stelleproponenteridesharing` (`CodVoto`,`Id`, `Persona`, `PiacereViaggio`, `Serieta`, `Comportamento`) VALUES ('16','3', '1', '4', '3', '5');


-- RIDE SHARING
INSERT INTO TragittoSharing VALUES ('4','4','60');

-- POSIZIONE SHARING
INSERT INTO PosizionePartenzaSharing VALUES ('4','1', '0');
INSERT INTO PosizioneArrivoSharing VALUES ('4','2', '30');

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('3', '4', '2', '10', '4',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '30', '1', '10', '3',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '3', '4', '2',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('4', '50', '2', '10', '4',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('4', '40', '2', '0', '3',current_timestamp());

INSERT INTO `progetto`.`chiamataridesharing` (`CodStradaArrivo`, `kmStradaArrivo`, `CodStradaPartenza`, `kmStradaPartenza`, `IdFruitore`, `TimeStamp`) VALUES ('1', '20', '1', '30', '2',current_timestamp());

INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', '4');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', '5');
INSERT INTO `progetto`.`adesioniridesharing` (`CodSharing`, `IdUtente`) VALUES ('4', '6');

CALL NumeroServiziErogati(1);
CALL NumeroServiziErogati(6);
CALL NumeroServiziErogati(7);
CALL NumeroServiziErogati(8);

CALL NumeroPostiRimanentiSharing(1);
CALL NumeroPostiRimanentiSharing(2);
CALL NumeroPostiRimanentiSharing(3);
CALL NumeroPostiRimanentiSharing(4);

CALL CaratteristicheAuto('BC100RT');
CALL CaratteristicheAuto('AW123OB');
CALL CaratteristicheAuto('NC122PU');
CALL CaratteristicheAuto('AM107XB');

CALL CalcolaCodaSharing(1);
CALL CalcolaCodaSharing(2);
CALL CalcolaCodaSharing(3);
CALL CalcolaCodaSharing(4);

CALL CalcolaCodaPool(1);

CALL CostoSharing(1);
CALL CostoSharing(2);
CALL CostoSharing(3);
CALL CostoSharing(4);

CALL classifica();
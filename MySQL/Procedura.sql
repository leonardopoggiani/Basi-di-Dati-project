DELIMITER $$
DROP PROCEDURE IF EXISTS CalcoloOrarioStimatoSharing $$
CREATE PROCEDURE CalcoloOrarioStimatoSharing(IN _codSharing INT)
BEGIN
	DECLARE esiste INT DEFAULT 0;
	DECLARE _kminizio DOUBLE DEFAULT 0;
    DECLARE _kmfine DOUBLE DEFAULT 0;
    DECLARE _limite INT DEFAULT 0;
    DECLARE _codstrada INT DEFAULT 0;
    DECLARE finito INT DEFAULT 0;
    DECLARE _densita DOUBLE DEFAULT 0;
    DECLARE tempo VARCHAR(6) DEFAULT 0;
    DECLARE autoN INT DEFAULT 0;
    DECLARE autoS INT DEFAULT 0;
    DECLARE autoP INT DEFAULT 0;
    DECLARE numeroauto INT DEFAULT 0;
    DECLARE iniziolimite DOUBLE DEFAULT 0;
    DECLARE finelimite DOUBLE DEFAULT 0;
    DECLARE _codstradalimite INT DEFAULT 0;
    DECLARE _velocita DOUBLE DEFAULT 0;
    DECLARE _nCorsie INT DEFAULT 0;
    
    #scorre tutte le strada di uno sharing
    DECLARE cursorSharing CURSOR FOR
		SELECT STS.codStrada ,STS.kmInizioStrada, STS.kmFineStrada
        FROM StradeTragittoSharing STS 
				#INNER JOIN RideSharing RS ON STS.CodSharing = RS.CodSharing
        WHERE STS.CodSharing = _codSharing;
	
    DECLARE cursorLimite CURSOR FOR
		SELECT LDV.ValoreLimite,  LDV.kmFine, LDV.kmInizio, LDV.codStrada
        FROM LimitiDiVelocita LDV 
			INNER JOIN StradeTragittoSharing STS ON STS.CodStrada = LDV.CodStrada
		WHERE 	STS.CodSharing = _codSharing
			AND LDV.kmInizio <= STS.kmFineStrada;
			
        
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;
		
    
    SET esiste = (SELECT COUNT(*)
					FROM RideSharing
					WHERE CodSharing = _codSharing);
                    
	IF(esiste = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Inserire uno sharing valido';
    ELSEIF esiste = 1 THEN
    OPEN cursorSharing;
   
    
    preleva: LOOP
		FETCH cursorSharing INTO _codstrada, _kminizio, _kmfine;
    
		IF(finito = 1) THEN
			LEAVE preleva;
		END IF;
		
        -- calcolo numero auto
		SET autoN = (
						SELECT 	COUNT(DISTINCT Targa)
						FROM 	TrackingNoleggio TN
						WHERE 	TN.CodStrada = _codstrada
								AND 
                                TN.kmStrada <= _kmfine
								AND 
                                TN.kmStrada >= _kminizio
					);
		
        SET autoP = (
						SELECT 	COUNT(DISTINCT Targa)
						FROM 	TrackingPool TP
						WHERE 	TP.CodStrada = _codstrada
								AND 
                                TP.kmStrada <= _kmfine
								AND 
                                TP.kmStrada >= _kminizio
					);
                            
        SET autoS = (
						SELECT 	COUNT(DISTINCT Targa)
						FROM 	TrackingSharing TS
						WHERE 	TS.CodStrada = _codstrada
								AND 
                                TS.kmStrada <= _kmfine
								AND 
                                TS.kmStrada >= _kminizio
					);
         
         
		SET _nCorsie =	(
							SELECT 	NumCorsie 
							FROM 	Strada S 
							WHERE	S.CodStrada = _codstrada
						);
         
		SET numeroauto = numeroauto + autoN + autoP + autoS; 
		SET _densita = 	numeroauto/(_kmfine - _kminizio)*_nCorsie;
		
        -- Secondo loop per ciclare limiti
		OPEN cursorLimite;
		limite: LOOP
				FETCH cursorLimite INTO _limite, finelimite, iniziolimite, _codstradalimite;
				
				IF(finito = 1) THEN
					SET finito = 0;
					LEAVE limite;
				END IF;
				
					CASE
						WHEN (_densita <= 35) THEN
							SET _velocita = _limite;
						WHEN (_densita > 35) AND (_densita <= 50) THEN
							SET _velocita = _limite*0.8;
						WHEN (_densita > 50) AND (_densita <= 65) THEN
							SET _velocita = _limite*0.6;
						WHEN (_densita > 65) AND (_densita <= 80) THEN
							SET _velocita = _limite*0.2;
						WHEN (_densita > 80) AND (_densita <= 100) THEN
							SET _velocita = _limite*0.1;
					END CASE;
						
						
					IF ((finelimite >= _kmfine) AND (iniziolimite > _kminizio) AND (_codstradalimite = _codstrada))  THEN
						
						SET tempo = tempo + ((_kmfine - iniziolimite)/_velocita)*60;
						
					ELSEIF ((finelimite < _kmfine) AND (iniziolimite >= _kminizio) AND (_codstradalimite = _codstrada))  THEN
						
						SET tempo = tempo + ((finelimite - iniziolimite)/_velocita)*60;
						
					ELSEIF ((finelimite >= _kmfine) AND (iniziolimite <= _kminizio) AND (_codstradalimite = _codstrada) )  THEN
						
						SET tempo = tempo + ((_kmfine - _kminizio)/_velocita)*60;
						
					ELSEIF ((finelimite < _kmfine) AND (iniziolimite < _kminizio) AND (_codstradalimite = _codstrada))  THEN
						
						SET tempo = tempo + ((finelimite - _kminizio)/_velocita)*60;
					
					END IF;
                
			END LOOP limite;
	
		CLOSE cursorLimite;
	
    END LOOP preleva;
        
	CLOSE cursorSharing;
    
    SELECT tempo AS TempoStimato;
    
    /*UPDATE RideSharing
    SET 	OraStimatoArrivo = tempo
    WHERE 	CodSharing = _codSharing;*/
    
	END IF;
    
END $$

DELIMITER ;
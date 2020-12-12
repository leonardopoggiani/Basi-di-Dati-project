DELIMITER $$
DROP PROCEDURE IF EXISTS CalcoloOrarioStimatoSharing $$
CREATE PROCEDURE CalcoloOrarioStimatoSharing(IN _codSharing INT)
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
		SET MESSAGE_TEXT = 'Sharing non esistente. Inserire uno sharing valido';
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
            SELECT densita;
            
            
            SELECT 	SUM(((LDV.kmFine - STS.kmInizioStrada)/LDV.ValoreLimite)*60) INTO T1
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio < STS.kmInizioStrada
					AND
					LDV.kmFine <= STS.kmFineStrada
					AND
					LDV.kmFine >= STS.kmInizioStrada;
					

			SELECT 	SUM(((LDV.kmFine - LDV.kmInizio)/LDV.ValoreLimite)*60) INTO T2
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio >= STS.kmInizioStrada
					AND
					LDV.kmFine <= STS.kmFineStrada;

					
			SELECT 	SUM(((STS.kmFineStrada - LDV.kmInizio)/LDV.ValoreLimite)*60) INTO T3
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio > STS.kmInizioStrada
					AND
					LDV.kmFine >= STS.kmFineStrada
					AND
					LDV.kmInizio <= STS.kmFineStrada;
					
			
			SELECT 	SUM(((STS.kmFineStrada - STS.kmInizioStrada)/LDV.ValoreLimite)*60) INTO T4
			FROM	StradeTragittoSharing STS INNER JOIN LimitiDiVelocita LDV ON STS.CodStrada = LDV.CodStrada
			WHERE 	STS.CodSharing = _codSharing
					AND 
					LDV.kmInizio <= STS.kmInizioStrada
					AND
					LDV.kmFine >= STS.kmFineStrada; 

	
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
				WHEN densita > 35 AND densita <= 50  THEN
					SET TempoStimato = TempoStimato + TempoStimato*1;
            END CASE;
            
            
            SELECT TempoStimato;
            
			UPDATE RideSharing
			SET OraStimatoArrivo = OraPartenza + INTERVAL TempoStimato MINUTE
            WHERE CodSharing = _codSharing;
    END IF;
END $$
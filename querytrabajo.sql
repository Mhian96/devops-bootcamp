-- 3144
-- REPORTE PARA TUFIBRA
WITH UltimaOS AS
(
    SELECT
        f.DescripcionFilial as 'Filial', -- arreglado
        os.idabonado,
        os.NumeroOS,
        pa.DscParametro as 'Estado Orden',
        os.FechaEjecucion,
        os.claseservicio,
        p.indEquipoRecogido,
        ROW_NUMBER() OVER
        (
            PARTITION BY os.idfilial, os.idabonado, os.claseservicio
            ORDER BY os.FechaIng DESC, os.idos DESC
        ) AS rn
    FROM Ordenservicio os
    INNER JOIN Abonadoservicio se
        ON os.idabonado = se.idabonado
        AND os.idfilial = se.idfilial
        AND os.claseservicio = se.claseservicio
    INNER JOIN OSpunto p
        ON os.idos = p.idos
    inner join Filial f
       on (os.idFilial = f.idFilial)
    inner join PArametro pa
       on (os.EstOS = pa.Parametro)
    WHERE os.Tipoos = '033'
      AND se.Estado = '005'
      and os.idfilial <> 2
      and pa.Dominio = '015'
)
SELECT
    Filial,
    idabonado,
    NumeroOS,
    [Estado Orden],
    FechaEjecucion,
    CASE claseservicio
        WHEN '001' THEN 'TV'
        WHEN '002' THEN 'INTERNET'
    END AS Servicio,
    CASE indEquipoRecogido
        WHEN 1 THEN 'REPROGRAMADO'
        WHEN 2 THEN 'PERDIDO'
        WHEN 3 THEN 'RECOGIDO'
        else ''
    END AS [Estado Equipo]
FROM UltimaOS
WHERE rn = 1;

-- select * from filial

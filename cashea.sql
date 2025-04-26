select a.CodClie, a.fechae, a.NumeroD, a.monto as montocxc, a.Saldo as saldocxc, b.Monto as montotarj,
case when b.CodTarj = '015' then 'monto financiado cashea'  end as despag, b.CodTarj
from SAACXC a inner join SAIPAVTA b
on a.numerod = b.numerod
where b.CodTarj = '015' and a.Saldo > 0






select *
from SAACXC a inner join SAIPAVTA b
on a.numerod = b.numerod
where b.CodTarj = '015' and a.Saldo > 0








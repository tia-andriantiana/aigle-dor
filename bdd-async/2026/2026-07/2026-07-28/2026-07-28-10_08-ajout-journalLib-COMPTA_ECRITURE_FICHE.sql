
CREATE OR REPLACE VIEW  COMPTA_ECRITURE_FICHE  AS 
  select ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET,ce.LETTRAGE,vc.FICHE  as lien, ce.dateSaisie, ce.DATEMODIF, ce.idModificateur, u.NOMUSER as idModificateurlib ,cj.desce as journalLib
  from COMPTA_ECRITURE ce
  left join V_CLASSEETFICHE vc on substr(ce.IDOBJET,1,3)=vc.LIBELLE
  left join utilisateur u  on ce.idmodificateur=u.REFUSER
  left join compta_journal cj on cj.id = ce.JOURNAL
 ;
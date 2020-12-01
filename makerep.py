import sqlite3
from appy.pod.renderer import Renderer

db = sqlite3.connect('remek_igs_2010.db')
cur = db.cursor()

#считаем общую статистику
cur.execute('''
    SELECT ( CASE
                 WHEN vp_oms='1' THEN 'в стационаре:'
	             WHEN vp_oms='2' THEN 'в дн. стационаре:'
	             WHEN vp_oms='3' THEN 'в амбулатории:'
	             WHEN vp_oms='4' THEN 'скорая мед. помощь:'
	         END
           ) AS vp_oms, count(VP_OMS), round(sum(S_ALL),2)
    FROM i2010
    GROUP BY vp_oms''')
gen_statistics = cur.fetchall()

cur.execute('SELECT COUNT(DISTINCT LPU) FROM i2010')
num_mo = cur.fetchone()[0]

cur.execute('SELECT DISTINCT LPU,N_SH_LPU,D_SH_LPU FROM i2010')
reestrs = cur.fetchall()
num_ree = len(reestrs)

#готовим данные для блока экспертиз по МО по счетам

class Level_MO:
    totals={'P':0.0,'S':0.0, 'Z':0.00,'A': 0.0}
    accs = ()

    def recalc_total(selfself):
        for acc in self.accs:
            for mek in acc.mecs:


class Level_ACC:
    num_acc = ''
    dat_acc = None
    s_all = 0.00
    mecs = ()





# собираем отчет
renderer = Renderer('firsttry.odt', globals(), 'aktI2010.odt')
renderer.run()

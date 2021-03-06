000002171127     FSHIFTRATESIF   E             DISK    RENAME(SHIFTRATES:SHIFTRATER)
000003171127     FALLSHIFT  IF   E           K DISK    RENAME(ALLSHIFT:ALLSHIFTR)
000005171215     FCONFIRMPY2CF   E             WORKSTN
000100171125     FPAYRPT    O    E             PRINTER OFLIND(*IN01)
000101171125     DHOURSOVER        S              3  0
000105171215     DMAIN             PR                  EXTPGM('PAYROLLPG2')
000106171215     DSHIFTTYPE                      30
000107171215     DMAIN             PI
000108171215     DSHIFTTYPE                      30
000109171215
000110171127     F/FREE
000111171125       READ SHIFTRATES;
000112171125       WRITE TITLE;
000113171125       WRITE COLHDG;
000114171125       READ ALLSHIFT;
000115171125       DOW NOT %EOF;
000116171125         EXSR PAYSR;
000117171125         IF *IN01;
000118171125           WRITE TITLE;
000119171125           WRITE COLHDG;
000120171125           *IN01 = *OFF;
000121171125         ENDIF;
000122171125         WRITE EMPDETAIL;
000123171125         READ ALLSHIFT;
000124171125       ENDDO;
000125171128       TOTEMPPAY = TOTREGPAY + TOTOVTPAY;
000126171125       WRITE TOTALS;
000131171125       EXFMT RECORD1;
000132171125       *INLR = *ON;
000133171125       RETURN;
000134171125       BEGSR PAYSR;
000135171125         SELECT;
000136171125           WHEN WORKSHIFT = 'D';
000137171125             HOURLYRATE = DAYRATE;
000138171125           WHEN WORKSHIFT = 'N';
000139171125             HOURLYRATE = NIGHTRATE;
000140171125           WHEN WORKSHIFT = 'A';
000141171125             HOURLYRATE = AFTNRATE;
000142171125         ENDSL;
000143171125
000144171125         SELECT;
000145171127           WHEN PAYGRADE = '1';
000146171128             EVAL(H) HOURLYRATE *= 1.073;
000147171127           WHEN PAYGRADE = '2';
000148171128             EVAL(H) HOURLYRATE *= 1.054;
000149171127           WHEN PAYGRADE = '3';
000150171128             EVAL(H) HOURLYRATE *= .955;
000151171125         ENDSL;
000152171125         HOURSOVER = HRSWORKED - 40;
000153171125         SELECT;
000154171125           WHEN (HOURSOVER > 0);
000155171125             REGULARPAY = 40 * HOURLYRATE;
000156171128             EVAL(H) OVERPAY = HOURSOVER * HOURLYRATE * 1.5;
000157171128             TOTREGPAY += REGULARPAY;
000158171128             TOTOVTPAY += OVERPAY;
000159171125           OTHER;
000160171125             REGULARPAY = HRSWORKED * HOURLYRATE;
000161171125             OVERPAY = 0;
000162171128             TOTREGPAY += REGULARPAY;
000164171125         ENDSL;
000165171125         TOTALPAY = REGULARPAY + OVERPAY;
000166171125       ENDSR;

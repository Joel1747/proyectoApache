$TTL    36000
@       IN      SOA     ns.fabulas.com. joel.danielcastelao.org. (
                     16112022           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS     ns.fabulas.com.  
ns      IN      A      10.1.2.254
oscuras    IN      A      10.1.2.250 
maravillosas   IN      CNAME  oscuras
 
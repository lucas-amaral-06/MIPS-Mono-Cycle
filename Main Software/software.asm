	# Carrega valores nos registradores
    addi $t0, $zero, 20    # $t0 = primeiro número
    addi $t1, $zero, 15    # $t1 = segundo número
    
    # Comparação básica (t0 > t1?)
    slt $s0, $t1, $t0      # $s0 = 1 se t0 > t1, senão 0
    

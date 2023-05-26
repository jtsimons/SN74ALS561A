restart

# OE#, ACLR#, ALOAD#, SCLR#, SLOAD# are active low inputs

# Initial values
add_force OE 0
add_force ACLR 0
add_force SCLR 1
add_force ALOAD 1
add_force SLOAD 1
add_force ENP 1
add_force ENT 1
add_force CLK {0 0ns} {1 5ns} -repeat_every 10ns

# Load decimal value 12
add_force -radix dec ABCD 12
run 100ns

# Deactivate ACLR#
add_force ACLR 1
run 10ns

# Activate ALOAD#
add_force ALOAD 0
run 10ns

# Deactivate ALOAD#
add_force ALOAD 1
run 50ns

# Activate SCLR#
add_force SCLR 0
run 20ns

# Deactivate SCLR#, activate SLOAD#, load decimal value 13
add_force SCLR 1
add_force SLOAD 0
add_force -radix dec ABCD 13
run 10ns

# Deactivate SLOAD#
add_force SLOAD 1
run 50ns

# Deactivate OE#
add_force OE 1
run 30ns

# Activate OE#
add_force OE 0
run 10ns

# Set ENP low
add_force ENP 0
run 20ns

# Set ENT low
add_force ENT 0
run 40ns

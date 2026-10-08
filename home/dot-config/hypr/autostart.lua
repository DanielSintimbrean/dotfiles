-- Start the scheduled night-light process with the desktop session.
o.launch_on_start("hyprsunset")

-- Open the coding workspace and mail client with the desktop session.
o.launch_on_start("/opt/t3code-nightly-bin/t3code")
o.launch_on_start("betterbird")

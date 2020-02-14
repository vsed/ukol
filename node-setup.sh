#!/bin/sh
apt update > /var/log/mujlog
apt -y install apache2 > /var/log/mujlog
apt -y install php > /var/log/mujlog

echo '<?php
$output = shell_exec('/usr/lib/cgi-bin/hostname.sh');
echo "<pre>$output</pre>";
?>
' > /var/www/html/index.php

echo '#!/bin/bash
echo $(hostname)
' > /usr/lib/cgi-bin/hostname.sh
chmod +x /usr/lib/cgi-bin/hostname.sh

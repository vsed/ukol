#!/bin/sh
apt update >> /var/log/mujlog
apt -y install apache2 php mariadb-client >> /var/log/mujlog

rm /var/www/html/index.html

echo '#!/bin/bash
echo $(hostname)
' > /usr/lib/cgi-bin/hostname.sh
chmod +x /usr/lib/cgi-bin/hostname.sh

systemctl restart apache2

db=$(nmap -sn 10.0.0.0/24|grep dbvm| grep -o -E '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

mysql -ucounter -pcounter -h $db -e "ALTER TABLE counter ADD $(hostname) int" -Dcounter >> /var/log/mujlog

echo '<?php
$output = shell_exec("/usr/lib/cgi-bin/hostname.sh");
echo "<pre>$output</pre>";' > /var/www/html/index.php
echo \$servername = "$(localhost)"\; >> /var/www/html/index.php
echo '$username = "counter";
$password = "counter";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";

$sql = "SELECT * FROM counter";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Value: " . $row "<br>";
    }
} else {
    echo "0 results";
}
$conn->close();
?>
' >> /var/www/html/index.php

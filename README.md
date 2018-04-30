# perl-deploy-module
Test task "Plugin Developer test"

Perl and Tomcat8 were chosen.

```bash
# For testing purposes only
export PERL_USE_UNSAFE_INC=1

# Deploy
./perl-deploy-module.pl --action deploy --application /usr/share/doc/tomcat8-docs/docs/appdev/sample/sample.war --config test.cfg

# Undeploy
./perl-deploy-module.pl --action undeploy --config test.cfg

# Start
./perl-deploy-module.pl --action start --config test.cfg

# Stop
./perl-deploy-module.pl --action stop --config test.cfg

# Check available
./perl-deploy-module.pl --action check-available --config test.cfg

# Check alive
./perl-deploy-module.pl --action check-alive --config test.cfg

# Use only command-line options
./perl-deploy-module.pl --action stop --config test.cfg --user pdm --password qwerty --path samp

```

import unittest

from snapstack import Plan, Setup, Step

class SnapstackTest(unittest.TestCase):

    def test_snapstack(self):
        '''
        _test_snapstack_

        Run a basic smoke test, utilizing our snapstack testing harness.

        '''
        gnocchi = Step(
            snap='gnocchi',
            script_loc='./tests/',
            scripts=['gnocchi_setup.sh',
                     'gnocchi_daemons.sh',
                     'gnocchi_commands.sh'],
            files=[
                'etc/snap-gnocchi/gnocchi/gnocchi.conf.d/indexer.conf',
                'etc/snap-gnocchi/gnocchi/gnocchi.conf.d/keystone.conf',
                'etc/snap-gnocchi/gnocchi/gnocchi.conf.d/statsd.conf',
                'etc/snap-gnocchi/gnocchi/gnocchi.conf.d/storage.conf',
            ],
            snap_store=False)

        gnocchi_cleanup = Step(
            script_loc='./tests/',
            scripts=['gnocchi_cleanup.sh'])

        plan = Plan(tests=[gnocchi], test_cleanup=[gnocchi_cleanup])
        plan.run()

use inc::Module::Install;
name 'Sub-Args';
all_from 'lib/Sub/Args.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

#/usr/lib/local/perl5 -w
# Question.t (C) 1998 Richard Foley
use Question;
use strict;
my ($t, $verbose);
my ($right, $wrong) = (4, 5); 

my $q = Question->new('2 + 2' => '4');
my $prompt = $question->ask('Question: '); 

$q->check_guess($right);

print ($q->answer !~ $wrong) ? "ok 1\n" : $not ok1 \n";
print ($q->answer =~ $right) ? "ok 2\n" : $not ok2 \n";

exit;

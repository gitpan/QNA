#!/usr/local/bin/perl 
#maths.cgi (C) 1998 Richard Foley
BEGIN { push @INC, ('..', '.', '../Quiz'); }
use MathsQuestion;
use Quiz;
use strict;
my @list;
my @qs = qw(add subtract multiply divide); 
foreach (@qs) {
	my $mq = MathsQuestion->new($_, 2);
	push (@list, $mq->question, $mq->answer);
}
my $quiz = Quiz->new(@list);
$quiz->prompt('Question: '); #going to use our own prompt.
while ($quiz->unanswered_questions) {
	print $quiz->next_question, "\n"; 
	$_ = <>;
	if ($quiz->check_guess($_)) {
		print $quiz->{right_message};
	} else {
		print $quiz->{wrong_message};
	}
}
$quiz->finished;
print $quiz->results;
exit;

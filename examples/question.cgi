#!/usr/local/bin/perl 
#question.cgi (C) 1998 Richard Foley
BEGIN { push @INC, ('..', '.', '../Quiz'); }
use Quiz;

#setup some questions.
my %q1 = ('3 * 2' => '6', '2 + 2' => '4', '7 - 2' => '5',);
my $quiz1 = Quiz->new(%q1);
$quiz1->prompt('Question: '); #going to use our own.
&test($quiz1);

my %q2 = (
	'What is the capital of England' => 'London',
	'What are white and fluffy and float in the sky' => 'clouds',
	'3 + 6' => '9',
);
my $quiz2 = Quiz->new(%q2);
&test($quiz2);

sub test {
	my $quiz = shift;
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
	print $quiz->results();
}

exit;

#
# Send hilighted messages & private messages to your cell phone via sms
# For irssi, based on highlightwin by Timo Sirainen & Mark Sangster
#
# Make sure to replace YOUR_NUMBER_HERE with your mobile number
#

use Irssi;
use POSIX;
use vars qw($VERSION %IRSSI); 

$VERSION = "0.02";
%IRSSI = (
    authors     => "Mike Dank - \@Famicoman",
    contact     => "famicoman\@gmail.com", 
    name        => "hilighttxt",
    description => "sms hilighted messages to your phone number",
    license     => "Public Domain",
    url         => "http://irssi.org/",
    changed     => "May 11 2016"
);

sub sanitize {
  my ($text) = @_;
  my $leftc = "&lt;";
  my $rightc = "&gt;";
  $text =~ s/$leftc g  $rightc//g;
  return $text;
}

sub sig_printtext {
    my ($dest, $text, $stripped) = @_;

    my $opt = MSGLEVEL_HILIGHT;

    if(Irssi::settings_get_bool('hilighttxt_showprivmsg')) {
        $opt = MSGLEVEL_HILIGHT|MSGLEVEL_MSGS;
    }
    
    if(
        ($dest->{level} & ($opt)) &&
        ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0
    ) {
        #$window = Irssi::window_find_name('hilight');
        
        if ($dest->{level} & MSGLEVEL_PUBLIC) {
            $text = $dest->{target}.": ".$text;
        }
        $text = strftime(
            Irssi::settings_get_str('timestamp_format')." ",
            localtime
        ).$text;
        #$window->print($text, MSGLEVEL_NEVER) if ($window);
        $text = sanitize($text);
        my $cmd = 'curl -X POST http://textbelt.com/text -d number=YOUR_NUMBER_HERE -d "message=' . $text . '"' . ' >\dev\null 2>&1';
        my $exitstatus = system($cmd);
        #my $results = `cmd`;
    }
}

#$window = Irssi::window_find_name('hilight');
Irssi::print("Loaded highlighttxt!") if (!$window);

Irssi::settings_add_bool('hilighttxt','hilighttxt_showprivmsg',1);

Irssi::signal_add('print text', 'sig_printtext');

# vim:set ts=4 sw=4 et:

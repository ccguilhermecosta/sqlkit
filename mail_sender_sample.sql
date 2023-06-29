BEGIN
UTL_MAIL.SEND(sender => 'teste@accenture.com'
, recipients => 'guilherme.f.costa@accenture.com'
, subject => 'Testmail'
, message => 'Hello');
END;
/
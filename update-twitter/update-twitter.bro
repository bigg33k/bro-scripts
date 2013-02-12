##! update-twitter.bro
##! add action types to the notice framework, fire off twitter scripts


@load ../main
@load base/utils/site

module Notice;

export {
	redef enum Action += {
		## Indicate that this log should be sent to twitter 
		## We just call the executable 
		UPDATE_TWITTER
	};

	redef record Info += {
		## If we tweet it let's mark it in the logs as tweeted
		tweeted: bool &log &optional;
	};

	## Notice types which should be tweeted
	const tweeted_types: set[Notice::Type] = {} &redef;
	## ex: 
	## redef enum tweeted_types += {('Malware_Hash_Registry_Match')}

	}
}

event notice(n: Notice::Info) &priority=-5
	{
	if ( UPDATE_TWITTER in n$actions )
		{
			# CALL TWIITER HERE
			local cmd = fmt("test.sh");
			# TODO: check for conn, may need to use n$src; may not have connection record
			piped_exec(cmd, fmt("%s %s", n$conn$id$orig_h, n$note));
		}
	}

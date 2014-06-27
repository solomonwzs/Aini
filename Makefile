# vim: noet:

REBAR= 			./rebar
DEPSOLVER_PLT= 	./.depsolver_plt


all:
	@$(REBAR) get-deps
	@$(REBAR) compile

edoc:
	@$(REBAR) doc

clean:
	@$(REBAR) clean

build_plt:
	@$(REBAR) build-plt

#dialyzer:
#	@$(REBAR) dialyze

$(DEPSOLVER_PLT):
	@dialyzer --output_plt $@ --build_plt \
		--apps erts kernel stdlib crypto ssh mnesia inets \
		-r deps/*/ebin

dialyzer:$(DEPSOLVER_PLT)
	@dialyzer --plt $^ ./ebin/*.beam

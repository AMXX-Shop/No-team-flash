#include <amxmodx>
#include <reapi>

#pragma semicolon 1

#define IMMUNITY ADMIN_LEVEL_H // comment out this line, if you don't want use immunity (default: ADMIN_LEVEL_H)
#define NTF // comment out this line, if you don't want block blinding from teammates

#if defined IMMUNITY
	#define bit_set(%0,%1) (%1 |= (1<<%0))
	#define bit_clear(%0,%1) (%1 &= ~(1<<%0))
	#define bit_valid(%0,%1) (%1 & (1<<%0))

	new g_Immunity;
#endif

public plugin_init() {
	register_plugin("No team flash", "0.1", "AMXX.Shop");

	#if defined IMMUNITY || defined NTF
	RegisterHookChain(RG_PlayerBlind, "FwdPlayerBlindPre");
	#endif
}

#if defined IMMUNITY
public client_putinserver(id) {
	if(is_user_bot(id) || is_user_hltv(id)) {
		return;
	}

	bit_clear(id, g_Immunity);

	if(get_user_flags(id) & IMMUNITY) {
		bit_set(id, g_Immunity);
	}
}
#endif

public FwdPlayerBlindPre(const id, const Inflictor, const Attacker) {
	#if defined IMMUNITY
	if(bit_valid(id, g_Immunity)) {
		return HC_SUPERCEDE;
	}
	#endif

	#if defined NTF
	if(get_member(id, m_iTeam) == get_member(Attacker, m_iTeam)) {
		return HC_SUPERCEDE;
	}
	#endif

	return HC_CONTINUE;
}

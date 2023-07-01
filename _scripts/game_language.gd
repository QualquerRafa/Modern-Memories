extends Node

#---------------------------------------------------------------------------------------------------
# GENERAL TERMS THAT SHOULD BE PADRONIZED ALL OVER THE GAME
#---------------------------------------------------------------------------------------------------
var system = {
	"confirm" : {
		"en" : "Confirm",
		"pt" : "Aceitar"
	},
	"close" : {
		"en" : "close",
		"pt" : "sair"
	},
	"duel" : {
		"en" : "Duel",
		"pt" : "Duelo"
	},
	"loading" : {
		"en" : "LOADING",
		"pt" : "CARREGANDO"
	},
	"points" : {
		"en" : "points",
		"pt" : "pontos"
	},
	"card" : {
		"en" : "card",
		"pt" : "carta"
	},
	"cards" : {
		"en" : "cards",
		"pt" : "cartas"
	},
}

var types = {
	"aqua" : {
		"en" : "Aqua",
		"pt" : "Aqua"
	},
	"beast" : {
		"en" : "Beast",
		"pt" : "Besta"
	},
	"beast-warrior" : {
		"en" : "Beast-Warrior",
		"pt" : "Besta-Guerreira"
	}, 
	"dinosaur" : {
		"en" : "Dinosaur",
		"pt" : "Dinossauro"
	},
	"dragon" : {
		"en" : "Dragon",
		"pt" : "Dragão"
	},
	"fairy" : {
		"en" : "Fairy",
		"pt" : "Fada"
	},
	"fiend" : {
		"en" : "Fiend",
		"pt" : "Demônio"
	}, 
	"fish" : {
		"en" : "Fish",
		"pt" : "Peixe"
	}, 
	"insect" : {
		"en" : "Insect",
		"pt" : "Inseto"
	}, 
	"machine" : {
		"en" : "Machine",
		"pt" : "Máquina"
	}, 
	"plant" : {
		"en" : "Plant",
		"pt" : "Planta"
	},
	"psychic" : {
		"en" : "Psychic",
		"pt" : "Psíquico"
	},
	"pyro" : {
		"en" : "Pyro",
		"pt" : "Piro"
	}, 
	"reptile" : {
		"en" : "Reptile",
		"pt" : "Réptil"
	}, 
	"rock" : {
		"en" : "Rock",
		"pt" : "Rocha"
	}, 
	"sea serpent" : {
		"en" : "Sea Serpent",
		"pt" : "Serpente Marinha"
	}, 
	"spellcaster" : {
		"en" : "Spellcaster",
		"pt" : "Mago"
	}, 
	"thunder" : {
		"en" : "Thunder",
		"pt" : "Trovão"
	},
	"warrior" : {
		"en" : "Warrior",
		"pt" : "Guerreiro"
	}, 
	"winged beast" : {
		"en" : "Winged Beast",
		"pt" : "Besta Alada"
	}, 
	"zombie" : {
		"en" : "Zombie",
		"pt" : "Zumbi"
	},
	
	#The 'count_as' extra types
	"amazon" : {
		"en" : "Amazon",
		"pt" : "Amazona"
	},
	"clown" : {
		"en" : "Clown",
		"pt" : "Palhaço"
	},
	"cyber" : {
		"en" : "Cyber",
		"pt" : "Cibernético"
	},
	"cyberdark" : {
		"en" : "Cyberdark",
		"pt" : "Cibersombrio"
	},
	"egg" : {
		"en" : "Egg",
		"pt" : "Ovo"
	},
	"female" : {
		"en" : "Female",
		"pt" : "Feminina"
	},
	"gear" : {
		"en" : "Gear",
		"pt" : "Engrenagem"
	},
	"gem" : {
		"en" : "Gem",
		"pt" : "Gema"
	},
	"harpie" : {
		"en" : "Harpie",
		"pt" : "Harpia"
	},
	"itsu" : {
		"en" : "Itsu",
		"pt" : "Itsu"
	},
	"masked" : {
		"en" : "Masked",
		"pt" : "Mascarado"
	},
	"ninja" : {
		"en" : "Ninja",
		"pt" : "Ninja"
	},
	"ojama" : {
		"en" : "Ojama",
		"pt" : "Ojama"
	},
	"roid" : {
		"en" : "Roid",
		"pt" : "Roide"
	},
	"train" : {
		"en" : "Train",
		"pt" : "Trem"
	},
	"turtle" : {
		"en" : "Turtle",
		"pt" : "Tartaruga"
	},
	"vampire" : {
		"en" : "Vampire",
		"pt" : "Vampiro"
	},
	
	#For error prevention
	"equip" : {
		"en" : "Equip",
		"pt" : "Equipamento"
	},
	"ritual" : {
		"en" : "Ritual",
		"pt" : "Ritual"
	},
	"spell" : {
		"en" : "Spell",
		"pt" : "Magia"
	},
	"trap" : {
		"en" : "Trap",
		"pt" : "Armadilha"
	},
	"any" : {
		"en" : "any",
		"pt" : "quaisquer"
	},
	"special_case": {
		"en" : "GLITCH",
		"pt" : "GLITCH"
	}
}

var attributes = {
	"dark" : {
		"en" : "Dark",
		"pt" : "Trevas"
	},
	"earth" : {
		"en" : "Earth",
		"pt" : "Terra"
	},
	"fire" : {
		"en" : "Fire",
		"pt" : "Fogo"
	},
	"light" : {
		"en" : "Light",
		"pt" : "Luz"
	},
	"water" : {
		"en" : "Water",
		"pt" : "Água"
	},
	"wind" : {
		"en" : "Wind",
		"pt" : "Vento"
	},
}

#---------------------------------------------------------------------------------------------------
# SCENES TEXT
#---------------------------------------------------------------------------------------------------
var main_menu = {
	#Initial Main Screen
	"new_game" : {
		"en" : "New Game",
		"pt" : "Novo Jogo"
	},
	"load_game" : {
		"en" : "Load Game",
		"pt" : "Carregar"
	},
	"options" : {
		"en" : "Options",
		"pt" : "Opções"
	},
	"update" : {
		"en" : "Update to ",
		"pt" : "Atualize para "
	},
	"unable_to_check_for_updates" : {
		"en" : "Unable to check for updates",
		"pt" : "Não foi possível procurar atualizações"
	},
	"version" : {
		"en" : "VERSION ",
		"pt" : "VERSÃO "
	},
	
	#Second Main Screen
	"campaign" : {
		"en" : "Campaign",
		"pt" : "Campanha"
	},
	"tournament" : {
		"en" : "Tournament",
		"pt" : "Torneio"
	},
	"free_duel" : {
		"en" : "Free Duel",
		"pt" : "Duelo Livre"
	},
	"build_deck" : {
		"en" : "Build Deck",
		"pt" : "Montar Deck"
	},
	"card_shop" : {
		"en" : "Card Shop",
		"pt" : "Loja de cartas"
	},
	"save_game" : {
		"en" : "Save Game",
		"pt" : "Salvar Jogo"
	},
	
	"save_confirmation_warning" : {
		"en" : "Are you sure you want to Save your game?\nThis will overwrite any previous savefile.",
		"pt" : "Tem certeza que quer Salvar seu jogo?\nIsso vai sobrescrever seu Save anterior."
	},
	"save_path_indicator" : {
		"en" : "File is stored at %appdata%/Godot/app_userdata/Modern Memories",
		"pt" : "Arquivo salvo em %appdata%/Godot/app_userdata/Modern Memories"
	}
}

var options_scene = {
	"scene_title" : {
		"en" : "Game Options",
		"pt" : "Opções do Jogo"
	},
	"volume_window" : {
		"en" : "Game Volume",
		"pt" : "Volume do Jogo"
	},
	"language_window" : {
		"en" : "Game Language",
		"pt" : "Idioma do Jogo"
	},
	"others_window" : {
		"en" : "Other Options",
		"pt" : "Outras Opções"
	},
	"others_window_1" : {
		"en" : "Auto-Save after Duels",
		"pt" : "Auto-Salvar após Duelos"
	},
	"credits_soundtrack" : {
		"en" : "Soundtrack: youtube.com/@lohweo",
		"pt" : "Trilha Sonora: youtube.com/@lohweo"
	},
	"credits_everything" : {
		"en" : "Everything else: youtube.com/@Rafa_SCN",
		"pt" : "Qualquer outra Coisa: youtube.com/@Rafa_SCN"
	}
}

var card_shop = {
	"scene_title" : {
		"en" : "Card Shop",
		"pt" : "Loja de Cartas"
	},
	"starchips" : {
		"en" : "STARCHIPS",
		"pt" : "ESTRELAS"
	},
	"card_code" : {
		"en" : "Card Code",
		"pt" : "Código da Carta"
	},
	"card_price" : {
		"en" : "Card Price",
		"pt" : "Preço da Carta"
	},
	"buy" : {
		"en" : "Buy",
		"pt" : "pegar"
	}
}

var deck_building = {
	"scene_title" : {
		"en" : "Deck Building",
		"pt" : "Montagem do Deck"
	},
	"name" : {
		"en" : "NAME",
		"pt" : "NOME"
	},
	"atk" : {
		"en" : "ATK",
		"pt" : "ATK"
	},
	"def" : {
		"en" : "DEF",
		"pt" : "DEF"
	},
	"type" : {
		"en" : "TYPE",
		"pt" : "TIPO"
	},
	"attr" : {
		"en" : "ATTR",
		"pt" : "ATRI"
	},
	"clear" : {
		"en" : "Clear",
		"pt" : "Limpar" #Zerar
	},
	"export_message" : {
		"en" : "YOUR DECK CODE WAS GENERATED",
		"pt" : "O CÓDIGO DO SEU DECK FOI GERADO"
	},
	"import_message_1" : {
		"en" : "PASTE THE DECK CODE BELLOW",
		"pt" : "COLE O CÓDIGO DO DECK ABAIXO"
	},
	"import_message_2" : {
		"en" : "Cards you don't have will be ignored",
		"pt" : "Cartas que você não possui serão ignoradas"
	},
	"import_placeholder" : {
		"en" : "PASTE CODE HERE",
		"pt" : "COLE O CÓDIGO AQUI"
	}
}

var free_duel = {
	"scene_title" : {
		"en" : "Free Duel",
		"pt" : "Duelo Livre"
	},
	"wins" : {
		"en" : "Wins: ",
		"pt" : "Vitórias: "
	},
	"losses" : {
		"en" : "Losses: ",
		"pt" : "Derrotas: "
	}
}

var duel_scene = {
	"you" : {
		"en" : "YOU",
		"pt" : "VOCÊ",
	},
	"turn" : {
		"en" : "Turn",
		"pt" : "Turno"
	},
	"turn_end" : {
		"en" : "Turn\nEnd",
		"pt" : "Turn\nEnd"
	},
	"no_field_bonus" : {
		"en" : "No Field Bonus",
		"pt" : "Sem Bônus de Campo"
	}
}

var reward_scene = {
	"scene_title" : {
		"en" : "Duel Results and Rewards",
		"pt" : "Resultado do Duelo e Recompensas"
	},
	"you" : {
		"en" : "YOU",
		"pt" : "VOCÊ"
	},
	"win" : {
		"en" : "WIN",
		"pt" : "VENCEU"
	},
	"lose" : {
		"en" : "LOSE",
		"pt" : "PERDEU"
	},
	"duel_info" : {
		"en" : "Duel Info",
		"pt" : "Informação"
	}
}

#---------------------------------------------------------------------------------------------------
# CARD DESCRIPTIONS
#---------------------------------------------------------------------------------------------------
var description_error = {
	"en" : "Card text not Defined.",
	"pt" : "Texto da Carta não encontrado."
}
var type_can_fuse_with = {
	"en" : " can do a Fusion with ",
	"pt" : " pode fazer Fusão com "
}

var count_as_part1 = {
	"en" : "This card can count as ",
	"pt" : "Essa carta pode contar como "
}
var count_as_part2 = {
	"en" : " for some Fusions.",
	"pt" : " para algumas Fusões."
}

#-------------
# SPELL CARDS
var equip_spell_atk = {
	"part1" : {
		"en" : "Increases a ",
		"pt" : "Aumenta o ataque de Monstros ",
	},
	"part2" : {
		"en" : " Monster's ATK by ",
		"pt" : " em "
	}
}
var equip_spell_stats = {
	"part1" : {
		"en" : "Increases a ",
		"pt" : "Aumenta o ATK e DEF de Monstros ",
	},
	"part2" : {
		"en" : " Monster's ATK and DEF by ",
		"pt" : " em "
	}
}
var equip_mage_power_special_case = {
	"part1" : {
		"en" : "Increases the ATK and DEF of a Monster by ",
		"pt" : "Aumenta o ATK e DEF de um Monstro em ",
	},
	"part2" : {
		"en" : " points times the number of Spell and Traps on your field.",
		"pt" : " pontos vezes o número de Magias e Armadilhas no seu campo."
	}
}

var field_spell = {
	"part1" : {
		"en" : "Increases the ATK of all ",
		"pt" : "Aumenta o ATK de todos os Monstros "
	},
	"part2" : {
		"en" : " monsters on the Field by 500 points and decreases their DEF by 400 points.",
		"pt" : " no campo em 500 pontos e diminui suas DEF em 400 pontos."
	}
}

var ritual_spell = {
	"part1" : {
		"en" : "By fulfiling the requirements of Level and offering a ",
		"pt" : "Ao preencher os requisitos de Nível e oferecer um Monstro do Tipo "
	},
	"part2" : {
		"en" : " Type Monster, \"",
		"pt" : ", \""
	},
	"part3" : {
		"en" : "\" will be Summoned to the Field.",
		"pt" : "\" será Invocado ao Campo."
	}
}

var spells_destroy_card = {
	"enemy_monsters" : {
		"en": "Monster",
		"pt" : "Monstro"
	},
	"enemy_spelltraps" : {
		"en" : "Spell and Trap",
		"pt" : "Magia e Armadilha"
	},
	
	"all_enemy1" : {
		"en" : "Destroys all of the opponent's ",
		"pt" : "Destrói todas as cartas de ",
	},
	"all_enemy2" : {
		"en" : " cards on the Field.",
		"pt" : " do seu oponente no Campo."
	},
	
	"targets_fusion_type1" : {
		"en" : "Destroys a random opponent's ",
		"pt" : "Destrói aleatoriamente um Monstro de "
	},
	"targets_fusion_type2" : {
		"en" : " Monster on the Field.",
		"pt" : " do seu oponente no Campo."
	},
	
	"fusion" : {
		"en" : "Fusion",
		"pt" : "Fusão"
	},
	"ritual" : {
		"en" : "Ritual",
		"pt" : "Ritual"
	},
	
	"type_specific_raigeki1" : {
		"en" : "Destroys all of the opponent's ",
		"pt" : "Destrói todos os monstros tipo "
	},
	"type_specific_raigeki2" : {
		"en" : " type Monsters on the Field.",
		"pt" : " do oponente no Campo."
	}
}

var special_description = {
	"en" : "This card Fused with the correct Monster will unleash their unique powers.",
	"pt" : "Essa carta Fundida com o Monstro correto vai liberar seu poder único."
}
var change_monster_position = {
	"block_attack" : {
		"en" : "Change all of your opponent's Attack Position Monsters to Defense Position.",
		"pt" : "Muda todos os monstros do seu oponente em Posição de Ataque para Posição de Defesa."
	},
	"stop_defense" : {
		"en" : "Change all of your opponent's Defense Position Monsters to Attack Position.",
		"pt" : "Muda todos os monstros do seu oponente em Posição de Defesa para Posição de Ataque."
	},
}
var sword_shield = {
	"en" : "Switch the ATK and DEF of all face-up Monsters on the Field.",
	"pt" : "Troca o ATK e DEF de todos os Monstros com face para cima no Campo."
}
var dice_power_change = {
	"atk_up" : {
		"en" : "Roll a dice and Power Up all your Monsters by 100 times the dice result.",
		"pt" : "Rola um dado e Fortalece todos os seus Monstros em 100 vezes o resultado do dado."
	},
	"atk_down" : {
		"en" : "Roll a dice and Power Down all of your opponent's Monsters by 100 times the dice result.",
		"pt" : "Rola um dado e Enfraquece todos os Monstros do oponente em 100 vezes o resultado do dado."
	}
}
var power_bond = {
	"en" : "Doubles the ATK of your strongest Fusion Machine Monster, at the cost of the same amount of your Life Points.",
	"pt" : "Dobra o ATK do seu Monstro Máquina de Fusão mais forte, ao custo da mesma quantidade em seus Pontos de Vida."
}
var tokens = {
	"part1" : {
		"en" : "Summons up to ",
		"pt" : "Invoca até ",
	},
	"part2" : {
		"en" : " Token Monsters on your side of the field.",
		"pt" : " Monstros Token no seu lado do campo."
	}
}
var tokens_life_change = {
	"tokens_for_life" : {
		"en" : "Gives you 500 Life Points for each Token Monster on your side of the Field.",
		"pt" : "Ganhe 500 Pontos de Vida por cada Monstro Token no seu lado do Campo."
	},
	"tokens_for_damage" : {
		"en" : "Damages your opponent's Life Points for 500 times the number of Token Monsters on your side of the Field.",
		"pt" : "Reduz os Pontos de Vida do seu oponente em 500 vezes o número de Monstros Token no seu lado do Campo."
	}
}
var change_of_heart = {
	"en" : "Get control of one Random Monster that belongs to your opponent.",
	"pt" : "Toma o controle de um Monstro Aleatório que pertence ao seu oponente."
}

#-------------
# TRAP CARDS
var trap_non_interrupt_extra_text = {
	"en" : " (This card does not interrupt the Battle Phase)",
	"pt" : " (Essa carta não interrompe a Fase de Batalha)"
}

var negate_attacker = {
	"en" : "Negates the Attack of an opposing Monster.",
	"pt" : "Nega o Ataque de um Monstro oponente."
}
var magic_cylinder = {
	"en" : "Negates the Attack of an opposing Monster and deals Life Point Damage to your opponent equal to that monster's ATK.",
	"pt" : "Nega o Ataque de um Monstro adversário e reduz os Pontos de Vida do seu oponente pelo ATK desse monstro."
}
var enchanted_javelin = {
	"en" : "Negates the Attack of an opposing Monster and recovers your own Life Points by that monster's ATK.",
	"pt" : "Nega o Ataque de um Monstro adversário e recupera seus Pontos de Vida pelo ATK desse monstro."
}
var mirror_force = {
	"en" : "Destroys all of the opposing Monsters in Attack Position.",
	"pt" : "Destrói todos os Monstros adversários em Posição de Ataque."
}
var ring_of_destruction = {
	"en" : "Destroy the opposing attacking Monster and deals Life Point Damage to both players equal to that monster's ATK.",
	"pt" : "Destrói o Monstro adversário atacante e reduz os Pontos de Vida dos dois jogadores pelo ATK desse monstro."
}
var destroy_attacker = {
	"basic_destroy" : {
		"en" : "Destroy the opposing attacking Monster",
		"pt" : "Destrói o Monstro adversário atacante"
	},
	"points_limit" : {
		"en" : " if it has ATK less than ",
		"pt" : " se ele tiver ATK menor que "
	}
}
var copy_as_token = {
	"en" : "Summons a copy of the opposing attacking Monster to your own side of the Field.",
	"pt" : "Invoca uma cópia do Monstro adversário atacante no seu lado do Campo."
}
var transform_in_token = {
	"en" : "Substitutes the opposing attacking Monster for a Token Copy with half it's power.",
	"pt" : "Substitui o Monstro adversário atacante por uma Cópia Token com metade de seu poder."
}
var fire_darts = {
	"en" : "Roll a dice and deal Life Point Damage to your opponent equal to 300 times the dice result.",
	"pt" : "Rola um dado e reduz os Pontos de Vida do seu oponent por 300 vezes o resultado do dado."
}
var fortify_tokens = {
	"en" : "All of your Token Monsters get 1000 DEF points.",
	"pt" : "Todos os seus Monstros Token ganham 1000 pontos de DEF."
}
var waboku = {
	"en" : "For the rest of this turn no player can have their Life Points changed.",
	"pt" : "Pelo resto desse turno nenhum dos jogadores pode ter seus Pontos de Vida alterados."
}
var gift_of_elf = {
	"en" : "Increase your own Life Points by 300 times the number of Monsters on both sides of the Field.",
	"pt" : "Aumenta seus Pontos de Vida em 300 vezes o número de Monstros nos dois lados do Campo."
}
var reveal_face_down = {
	"en" : "All of your opponent's Face-Down Monsters are flipped Face-Up without activating their effects.",
	"pt" : "Todos os Monstros Face para Baixo do seu adversário são virados para cima sem ativar seus efeitos."
}
var battle_trap = {
	"part1" : {
		"en" : "Increases the ",
		"pt" : "Aumenta os pontos de "
	},
	"part2" : {
		"en" : " of your attacked Monster by 500 points.",
		"pt" : " do seu Monstro atacado em 500 pontos."
	}
}

#-------------
# MONSTER CARDS
var token_monster = {
	"en" : "Token Monsters cannot be used for Fusions or be Equiped.",
	"pt" : "Monstros Token não podem ser usados para Fusões ou serem Equipados."
}

#on_attack effects
var on_attack_first = {
	"en" : "When this Monster attacks: ",
	"pt" : "Quando esse Monstro ataca: "
}

var anti_flip = {
	"en" : "It doesn't trigger Flip Effects from face-down Monsters.",
	"pt" : "Ele não ativa Efeitos de Virar de Monstros virados para baixo."
}
var ignore_spelltrap = {
	"en" : "It doesn't trigger opponent's Spell and Trap cards.",
	"pt" : "Ele não ativa as Magias e Armadilhas do oponente."
}
var piercing = {
	"en" : "It inflicts Piercing Damage on Defense Position Monsters.", 
	"pt" : "Ele inflinge Dano Perfurante em Monstros na Posição de Defesa."
}
var multiple_attacker = {
	"en" : "It can attack a Second Time in this same turn.",
	"pt" : "Ele pode atacar uma Segunda Vez nesse mesmo turno."
}
var can_direct = {
	"en" : "It can attack the opponent's Life Points directly.",
	"pt" : "Ele pode atacar os Pontos de Vida do oponente diretamente."
}
var toon = {
	"en" : "It can attack the opponent's Life Points directly at the cost of 500 LP.",
	"pt" : "Ele pode atacar os Pontos de Vida do oponente diretamente ao custo de 500 PV."
}
var change_position = {
	"en" : "It changes it's Battle Position at the end of combat.",
	"pt" : "Ele troca sua Posição de Batalha depois do combate."
}
var mutual_banish = {
	"en" : "It destroys the opponent's Monster along with itself.",
	"pt" : "Ele destrói o Monstro do oponente junto de si mesmo."
}
var injection_fairy = {
	"en" : "At the cost of 2000 Life Points, it gains 3000 ATK points during this battle.",
	"pt" : "Ao custo de 2000 Pontos de Vida, ele ganha 3000 pontos de ATK durante essa batalha."
}
var rocket_warrior = {
	"en" : "It causes the opponent's Monster to lose 500 ATK points.",
	"pt" : "Ele faz o Monstro do oponente perder 500 pontos de ATK."
}
var burn = {
	"part1" : {
		"en" : "It causes Life Point damage to the opponent equal to ",
		"pt" : "Ele causa dano aos Pontos de Vida do oponente igual a "
	},
	"monster_atk_dmg" : {
		"en" : "the base ATK of the destroyed Monster.",
		"pt" : "o ATK base do Monstro destruído."
	}
}
var lifepoint_change = {
	"lifepoint_cost" : {
		"en" : "You must pay ",
		"pt" : "Você deve pagar "
	},
	"lifepoint_up" : {
		"en" : "You gain ",
		"pt" : "Você ganha "
	},
	"final" : {
		"en" : " Lifepoints.",
		"pt" : " Pontos de Vida."
	}
}
var get_power = {
	"en" : "It increases it's own ATK by ",
	"pt" : "Ele aumenta seu próprio ATK em "
}
var mill = {
	"en" : "The opponent Deck loses ",
	"pt" : "O Deck do oponente perde "
}

#on_defend effects
var on_defend_first = {
	"en" : "When this Monster is attacked: ",
	"pt" : "Quando esse Monstro é atacado: "
}

var cant_die = {
	"basic" : {
		"en" : "It can't be destroyed by Battle",
		"pt" : "Ele não pode ser destruido por Batalha"
	},
	"extra" : {
		"en" : " unless it battles a ",
		"pt" : " a não ser por um Monstro de "
	},
	"final" : {
		"en" : " Monster.",
		"pt" : "."
	}
}
var debuff = {
	"en" : "It reduces the attacker's ATK by ",
	"pt" : "Ele reduz o ATK do atacante em "
}
var ehero_core = {
	"en" : "It doubles it's own ATK during this battle only.",
	"pt" : "Ele dobra seu próprio ATK durante apenas essa batalha."
}
var no_damage = {
	"en" : "It's controller will not take Battle Damage.",
	"pt" : "Seu controlador não levará Dano de Batalha."
}
var return_damage = {
	"en" : "The opposing player takes the same Battle Damage as you do.",
	"pt" : "O jogador adversário leva o mesmo Dano de Batalha que você."
}

#on_flip effects
var on_flip_first = {
	"en" : "When this Monster is Flipped: ",
	"pt" : "Quando esse Monstro é Virado: "
}

var jigen_bakudan = {
	"en" : "It destroys all of your Monsters on the Field and deal half the sum of their Attack to the opponent's LP.",
	"pt" : "Ele destrói todos os seus Monstros no Campo e reduz metade da soma dos Ataques deles dos PV do oponente."
}
var slate_warrior = {
	"en" : "It increases it's own ATK and DEF by 500 points.",
	"pt" : "Ele aumenta seu próprio ATK e DEF em 500 pontos."
}
var monster_destroy_effects = {
	"all_enemy_monsters" : {
		"en" : "It destroys all of your opponent's Monsters on the Field.",
		"pt" : "Ele destrói todos os Monstros no Campo do seu adversário."
	},
	"both_sides_monsters" : {
		"en" : "It destroys all Monsters on both sides of the Field.",
		"pt" : "Ele destrói todos os Monstros nos dois lados do Campo."
	},
	"level4_enemy_monsters" : {
		"en" : "It destroys all Level 4 Monsters on your opponent's side of the Field.",
		"pt" : "Ele destrói todos os Monstros Nível 4 no Campo do seu adversário."
	},
	"random_monster" : {
		"en" : "It destroys a Random Monster on your opponent's side of the Field.",
		"pt" : "Ele destrói um Monstro Aleatório no Campo do seu adversário."
	},
	"random_spelltrap" : {
		"en" : "It destroys a Random Spell or Trap card on your opponent's side of the Field.",
		"pt" : "Ele destrói uma Carta de Magia ou Armadilha Aleatória no Campo do seu adversário."
	},
	"atk_highest" : {
		"en" : "It destroys the Strongest Monster on your opponent's side of the Field.",
		"pt" : "Ele destrói o Monstro mais Forte no Campo do seu adversário."
	}
}

#on_summon effects
var on_summon_first = {
	"en" : "When this Monster is Summoned: ",
	"pt" : "Quando esse Monstro é Invocado: "
}

var air_neos = {
	"en" : "It increases it's own ATK by the difference between both player's Life Points.",
	"pt" : "Ele aumenta seu ATK pela diferença entre os Pontos de Vida dos dois jogadores."
}
var attribute_booster = {
	"part1" : {
		"en" : "It increases the ATK of ",
		"pt" : "Ele aumenta o ATK de Monstros "
	},
	"part2" : {
		"en" : " Monsters by 500 points and decreases the ATK of ",
		"pt" : " em 500 pontos e diminui o ATK de Monstros "
	},
	"part3" : {
		"en" : " by 400 points.",
		"pt" : " em 400 pontos."
	},
}
var attribute_reptile = {
	"en" : "It destroys all Monsters that aren't Attribute ",
	"pt" : "Ele destrói todos os Monstros que não sejam Atributo "
}
var castle_power_up = {
	"en" : "It increases Fiend and Zombie type Monster's ATK and DEF on your field by 200 points.",
	"pt" : "Ele aumenta o ATK e DEF de Monstros tipo Demônio e Zumbi no seu campo em 200 pontos."
}
var copy_atk = {
	"en" : "It copies the ATK and DEF of the strongest Monster on your opponent's side of the field.",
	"pt" : "Ele copia o ATK e DEF do Monstro mais forte no lado do Campo do seu oponente."
}
var count_as_power_up = {
	"part1" : {
		"en" : "It increases it's own ATK by ",
		"pt" : "Ele aumenta seu ATK em "
	},
	"part2" : {
		"en" : " points for each ",
		"pt" : " pontos para cada Monstro "
	},
	"part3" : {
		"en" : " Monster on your side of the Field.",
		"pt" : " no seu lado do Campo."
	}
}
var cyber_stein = {
	"en" : "At the cost of 5000 Life Points, it transforms itself into the Strongest Monster in the player's Deck.",
	"pt" : "Ao custo de 5000 Pontos de Vida, ele se transforma no Monstro mais Forte no Deck do jogador."
}
var damage_monster_count = {
	"part1" : {
		"en" : "It damages your opponent's Life Points by ",
		"pt" : "Ele reduz os Pontos de Vida do seu oponente em "
	},
	"part2" : {
		"en" : " points times the number of Monsters on your side of the Field.",
		"pt" : " pontos vezes o número de Monstros no seu lado do Campo." 
	}
}
var lifeup_monster_count = {
	"part1" : {
		"en" : "It increases your Life Points by ",
		"pt" : "Ele aumenta seus Pontos de Vida em "
	},
	"part2" : {
		"en" : " points times the number of Monsters on your side of the Field.",
		"pt" : " pontos vezes o número de Monstros no seu lado do Campo." 
	}
}
var deck_for_stat = {
	"part1" : {
		"en" : "It removes up to 3 cards from your Deck and increases it's ",
		"pt" : "Ele remove até 3 cartas do seu Deck e aumenta seu "
	},
	"part2" : {
		"en" : " by 500 points times the number of cards removed.",
		"pt" : " em 500 pontos vezes o número de cartas removidas."
	}
}
var specific_type_destroy = {
	"part1" : {
		"en" : "It destroys a random ", # 
		"pt" : "Ele destrói um Monstro aleatório tipo ",
	},
	"part2" : {
		"en" : "-type Monster on your opponent's side of the Field.",
		"pt" : " no Campo do seu adversário."
	}
}
var equip_boost = {
	"en" : "It increases it's own ATK by 500 points for each ATK boost it has received.",
	"pt" : "Ele aumenta seu próprio ATK em 500 pontos para cada aumento de ATK que já recebeu."
}
var flip_enemy_down = {
	"en" : "It Flips an opponent's Monster to Face-Down Defense Position, removing it's ATK and DEF boosts.",
	"pt" : "Ele Vira um Monstro do oponente para Baixo em Posição de Defesa, removendo seus aumentos de ATK e DEF."
}
var friends_power_up = {
	"part1" : {
		"en" : "It increases other ",
		"pt" : "Ele aumenta o ATK e DEF de outros Monstros "
	},
	"part2" : {
		"en" : "-type Monsters ATK and DEF on your side of the Field by ",
		"pt" : " no seu lado do Campo em "
	}
}
var gandora = {
	"en" : "By paying half of your LP, it destroys all Monsters on both sides of the Field and increases it's ATK and DEF by 300 times the number of Monsters destroyed.",
	"pt" : "Ao pagar metade dos seus PV, ele destrói todos os Monstros nos dois lados do Campo e aumenta seu ATK e DEF em 300 vezes o número de Monstros destruídos."
}
var white_horned = {
	"en" : "It destroys all Spell and Trap cards on your opponent's side of the Field and increases it's ATK and DEF by 300 times the number of cards destroyed.",
	"pt" : "Ele destrói todas as cartas de Magia e Armadilha no Campo do seu adversário e aumenta seu ATK e DEF em 300 vezes o número de cartas destruídas."
}
var graveyard_power_up = {
	"part1" : {
		"en" : "It increases it's ATK and DEF by ",
		"pt" : "Ele aumenta seu ATK e DEF em "
	},
	"part2" : {
		"en" : " points for each card out of your Deck.",
		"pt" : " pontos para cada carta fora do seu Deck."
	}
}
var honest = {
	"part1" : {
		"en" : "A random ",
		"pt" : "Um Monstro "
	},
	"part2" : {
		"en" : " Monster on your side of the Field gets it's ATK increased by 1000 points.",
		"pt" : " aleatório no seu lado do Campo tem seu ATK aumentado em 1000 pontos."
	}
}
var jinzo = {
	"part1" : {
		"en" : "It destroys all of your opponent's Spell and Traps on the Field",
		"pt" : "Ele destrói todas as Magias e Armadilhas no Campo do seu adversário"
	},
	"part2" : {
		"en" : " and causes LP damage equal to ",
		"pt" : " e causa dano aos PV igual a "
	},
	"part3" : {
		"en" : " points times the number of cards destroyed.",
		"pt" : " pontos vezes o número de cartas destruídas."
	}
}
var monster_change_field = {
	"en" : "It changes the Field to boost the Attribute ",
	"pt" : "Ele muda o Campo para fortalecer o Atributo "
}
var monster_count_boost = {
	"part1" : {
		"en" : "It increases it's ATK by ",
		"pt" : "Ele aumenta seu ATK em "
	},
	"part2" : {
		"en" : " points for each other Monster on your side of the Field.",
		"pt" : " pontos para cada outro Monstro no seu lado do Campo."
	}
}
var self_power_up = {
	"part1" : {
		"en" : "It increases it's ATK and DEF by ",
		"pt" : "Ele aumenta seu ATK e DEF em "
	},
	"part2" : {
		"en" : " points for each Monster with the same Type as it on your side of the Field.",
		"pt" : " pontos para cada Monstro com o mesmo Tipo que ele no seu lado do Campo."
	},
	"buster_blader" : {
		"en" : "500 points for each Dragon Monster on your side of the Field.",
		"pt" : "500 pontos para cada Monstro Dragão no seu lado do Campo."
	},
	"random_dice" : {
		"en" : "100 points times the result of a Dice Roll.",
		"pt" : "100 pontos vezes o resultado de um Rolar de Dados."
	},
	"same_attribute" : {
		"en" : "500 points for each Monster with the same Attribute as it on your side of the Field.",
		"pt" : "500 pontos para cada Monstro com o mesmo Atributo que ele no seu lado do Campo."
	},
	"spelltrap_count" : {
		"en" : "500 points for each Spell and Trap card on your side of the Field.",
		"pt" : "500 pontos para cada carta de Magia e Armadilha no seu lado do Campo."
	}
}
var stop_defense = {
	"en" : "It changes all of your opponent's Defense Position Monsters to Attack Position.",
	"pt" : "Ele muda todos os monstros do seu oponente em Posição de Defesa para Posição de Ataque."
}
var summon_pharaoh = {
	"en" : "It Summons it's Servants to aid it in Battle.",
	"pt" : "Ele Invoca seus Servos para ajudá-lo em Batalha."
}
var super_robo = {
	"en" : "It increases it's ATK and the ATK of all opposite gender Super Robo on your side of the Field by 1000 points.",
	"pt" : "Ele aumenta seu ATK e o ATK de todos os Super Robos do gênero oposto no seu lado do Campo em 1000 pontos."
}
var wicked_avatar = {
	"en" : "It's ATK and DEF becomes 100 points higher than the Strongest Monster on the Field.",
	"pt" : "Seu ATK e DEF se tornam 100 pontos maior que o Monstro mais Forte no Campo."
}
var wicked_dreadroot = {
	"en" : "It halves the ATK and DEF of all other Monsters on both sides of the Field.",
	"pt" : "Ele divide pela metade o ATK e DEF de todos os outros Monstros nos dois lados do Campo."
}
var wicked_eraser = {
	"en" : "It's ATK and DEF becomes 1000 times the total number of Cards on your opponent's side of the Field.",
	"pt" : "Seu ATK e DEF se tornam 1000 vezes o número total de Cartas no lado do Campo do seu oponente."
}




#Ritual Monsters effects
var on_ritual_summon = {
	"en" : "When this Monster is Ritual Summoned: ",
	"pt" : "Quando esse Monstro é Invocado por Ritual: "
}
var on_ritual_death = {
	"en" : "When this Ritual Monster is Destroyed: ",
	"pt" : "Quando esse Monstro Ritual é Destruído: "
}
var on_ritual_attack = {
	"en" : "When this Ritual Monster Attacks: ",
	"pt" : "Quando esse Monstro Ritual Ataca: "
}
var on_ritual_defend = {
	"en" : "When this Ritual Monster is Attacked: ",
	"pt" : "Quando esse Monstro Ritual é Atacado: "
}

var ritual_summon_friend = {
	"en" : "It summons an Ally to fight.",
	"pt" : "Ele invoca um Aliado para lutar."
}
var ritual_copy_as_token = {
	"en" : "It creates a Token of the Strongest opposing Monster.",
	"pt" : "Ele cria um Token do Monstro adversário mais Forte."
}
var ritual_destroy_highest = {
	"en" : "It destroys the Strongest opposing Monster.",
	"pt" : "Ele destrói o Monstro adversário mais Forte."
}
var ritual_destroy_all_monsters = {
	"en" : "It destroys all the opposing Monsters on the Field.",
	"pt" : "Ele destrói todos os Monstros adversários no Campo."
}
var ritual_destroy_all_spelltraps = {
	"en" : "It destroys all the opposing Spells and Traps on the Field.",
	"pt" : "Ele destrói todas as Magias e Armadilhas adversários no Campo."
}
var ritual_spelltrap_power_up = {
	"en" : "It's ATK is increased by the number of Spell and Traps on your Field.",
	"pt" : "Seu ATK é aumentado pelo número de Magias e Armadilhas no seu Campo."
}
var ritual_same_type_power_up = {
	"en" : "It increases the ATK and DEF of Monsters with the same Type as it on your Field.",
	"pt" : "Ele aumenta o ATK e DEF de Monstros com o mesmo Tipo que ele no seu Campo."
}
var ritual_dice_power_up = {
	"en" : "It rolls a Dice and increases the ATK of Monsters on your Field.",
	"pt" : "Ele rola um Dado e aumenta o ATK de Monstros no seu Campo."
}
var ritual_self_type_power_up = {
	"en" : "It's ATK is increased by the number of Monster with the same Type as it on your Field.",
	"pt" : "Seu ATK é aumentado pelo número de Monstros com o mesmo Tipo que ele no seu Campo."
}
var ritual_sword_shield = {
	"en" : "It switches the ATK and DEF of all face-up Monsters on the Field.",
	"pt" : "Ele troca o ATK e DEF de todos os Monstros com face para cima no Campo."
}
var ritual_mill_deck = {
	"en" : "It discards Cards from the opponent's Deck.",
	"pt" : "Ele descarta Cartas do Deck do oponente."
}
var ritual_death_successor = {
	"en" : "It Summons a Monster to take it's place.",
	"pt" : "Ele Invoca um Monstro para tomar seu lugar."
}
var ritual_chaos_max = {
	"en" : "It doubles it's base ATK.",
	"pt" : "Ele dobra seu ATK base."
}
var ritual_double_ATK = {
	"en" : "It doubles it's current ATK.",
	"pt" : "Ele dobra seu ATK atual."
}
var ritual_return_damage = {
	"en" : "The opposing player takes the same Battle Damage as you do.",
	"pt" : "O jogador adversário leva o mesmo Dano de Batalha que você."
}








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
		"pt" : "Lojinha"
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
	"en" : "At the cost of 2000 Life Points, it gains 3000 ATK points.",
	"pt" : "Ao custo de 2000 Pontos de Vida, ele ganha 3000 pontos de ATK."
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
		"pt" : " Pontos de vida."
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

#on_flip effects

#on_summon effects







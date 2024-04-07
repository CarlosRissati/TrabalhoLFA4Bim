extends Node

var index_lin: int = 0

var linguagens: = [
	"{aⁿ|n>0}",
	"{abⁿ|n>0}",
	"{aⁿbⁿ|n>0}",
	"{cⁿaⁿ|n>0}",
	"{abⁿc|n>0}",
	"{aᶦbʲcᵏ|i = j+k, j>0, k>0}",
	"{aᶦbʲcᵏ|k = i+j, i>0, j>0}",
	"{aⁿb²ᵐccbᵖ|n≥1, m≥1, p≥1}"
]

var dicionario = {
	"{aⁿ|n>0}": ["a","aa","aaa","aaaa","aaaaa"],
	"{abⁿ|n>0}": ["ab","abb","abbb","abbbb","abbbbb"],
	"{aⁿbⁿ|n>0}": ["ab","aabb","aaabbb","aaaabbbb","aaaaabbbbb"],
	"{cⁿaⁿ|n>0}": ["ca","ccaa","cccaaa","ccccaaaa","cccccaaaaa"],
	"{abⁿc|n>0}": ["abc","abbc","abbbc","abbbbc","abbbbbc"],
	"{aᶦbʲcᵏ|i = j+k, j>0, k>0}": ["aabc","aaabbc","aaabcc","aaaabbcc","aaaabbbc"],
	"{aᶦbʲcᵏ|k = i+j, i>0, j>0}": ["abcc","aabccc","abbccc","aabbcccc","abbbcccc"],
	"{aⁿb²ᵐccbᵖ|n≥1, m≥1, p≥1}": ["abbccb", "abbbbccb", "aabbccbb", "aabbbbccbbb", "abbccbbb", "aaabbccb", "aaaabbccbbb", "abbccbbbbb", "aaaaabbccb"],
}

func get_prompt() -> String:
	
	var chave = linguagens[index_lin]
	var arr = dicionario[chave]
	
	var palavra_index = randi() % arr.size()
	var palavra = arr[palavra_index]
	return palavra

func get_linguagem() -> String:
	index_lin = randi() % linguagens.size()
	var lingua = linguagens[index_lin]
	return lingua


func get_linguagem_array():
	var array = []
	array.resize(3)
	for i in 3:
		array[i] = linguagens[index_lin - i] #godot permite a interação inversa, então se a variavel i é negativa ela pega o size e diminui por esse i negativo dando o novo valor
	return array

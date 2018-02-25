-- $Name:Память$
-- $Version:0.3$
instead_version "1.5.3"

require "hideinv"
require "para"
require "quotes"
require "dash"
require "xact"
require "theme"

game.codename = 'UTF-8';
game.act = 'Странно...';
game.inv = 'Хм...';
game.use = 'Нет.';

main = room {
	nam = 'Ночь...',
	dsc = [[Что происходит?! Я убегаю. В руках оружие. Обрез.
Жарко. Лето. Я в футболке с какой-то надписью и шортах. На ногах
разодраные кеды.^^
В голове вертится одно слово: "сеновал". Оно почему-то очень важное.^^
Я один. За мной кто-то гонится. Стараюсь не оборачиваться. Бежать
тяжело. Да и ничего почти не видно. Подсветить нечем.^^
Чёрт! Споткнулся. Слышу довольное рычание сзади. Кто это?!
Что ему нужно? Или им?^^
Я вижу впереди какое-то здание. Кажется, это дом. Может там
кто-то есть? Хотя свет не горит. В любом случае мне ничего
не остаётся, кроме как {goto_build|забежать в него}.]],
	obj = {
		xact('goto_build', code[[walk(veranda_screen);]]),
	},
	enter = function()
		set_music('music/night.ogg');
	end,
	pic = 'images/main.png',
}

veranda_screen = room {
	nam = 'Веранда',
	dsc = [[Подбегаю к дому.^^
Дверь в веранду раскрыта на распашку. Забегаю.
В панике начинаю дёргать дверь в дом. Заперто. Но рядом есть
окно. Оно открыто. {goto_intobuild|Вперёд!}]],
	obj = {
		xact('goto_intobuild', code[[walk(intobuild_screen);]]),
	},
}

intobuild_screen = room {
	nam = 'Дом',
	dsc = [[Я в доме. Здесь очень темно. Но всё же видны силуэты
предметов. Свет луны попадает сквозь окна.^^
Я торопливо пробираюсь в комнату, похожую на кухню. Я не знаю даже
зачем. Просто я в панике. И вдруг цепляю что-то металлическое на
полу. Кажется, это кастрюля. Спотыкаюсь. Падаю. И с ужасом осознаю,
что лечу куда-то {goto_basement|вниз}.]],
	obj = {
		xact('goto_basement', code[[walk(basement_screen)]]),
	},
}

basement_screen = room {
	nam = 'Погреб',
	dsc = [[Я прихожу в сознание... Я цел. Правда болит голова.
Кажется я ей сильно ударился.^^
Где я?.. Вверху виден тусклый свет. Я вспомнил как я упал. Понятно,
это погреб.^^
Надо выбираться... Стоп. От кого я бежал?! Почему у меня в руках был
дробовик?! Какой сейчас год?! Кто я?!^^
Вот так, в каком-то погребе, в темноте я потерял {goto_memory|память...}]],
	obj = {
		xact('goto_memory', code[[walk(memory_screen)]]),
	},
	enter = function()
		stop_music();
	end,
}

memory_screen = room {
	nam = 'Память',
	dsc = [[Игра создана в рамках конкурса Вжж!^^
Автор: Евгений Ефремов (Jhekasoft)^^
15-16 августа, 2012 год^^
Позже, уже после конкурса, были добавлены изображения и тема оформления.^^
Дата последнего релиза: 25.02.2018.^^
{start|Начать}]],
	obj = {
		xact('start', code[[walk(basement)]]),
	},
	enter = function()
		set_music('music/memory.ogg');
	end,
}

basement = room {
	nam = 'Погреб',
	dsc = [[Я стою в погребе. Чувствуется противный запах. Возможно
здесь крысы водятся.]],
	obj = {'darkness', 'basement_door', 'table'},
	enter = function()
		take('clothes');
		take('gun');
		set_music('music/fear.ogg');
	end,
}

clothes = obj {
	nam = 'одежда',
	inv = function(s)
		p 'Моя одежда: футболка и шорты.';
		if here() == basement then
			p [[На футболке что-то написано. Что
именно я не помню. И не могу вспомнить. Надпись чувствуется на ощупь. Как будто
её делали какой-то краской. Точнее, это символ, а уже под ним надпись. Но
разглядеть в такой темноте невозможно ничего.]];
		else
			put('goto_hayloft', 'build_kitchen');
			p [[На футболке символ анархии: "А" в круге. Под ним подпись:
"Anvan". Не знаю, что значит подпись, но кажется я анархист. Сеновал...
Я вспомнил! Я должен с кем-то встретится на сеновале. Именно туда я и бежал!
Я вспонил этот дом. Сеновал расположен за ним...]];
		end
	end,
}

gun = obj {
	var {
		charged = true;
	},
	nam = 'дробовик',
	inv = function(s)
		p 'Дробовик.';
		if s.charged then
			p 'Он заряжен. Видимо я им от кого-то защищался. Вот только от кого?';
		else
			p 'Пустой. Заряд я потратил на замок.';
		end
	end,
	use = function(s, w)
		if w == closet then
			s.charged = false;
		end
	end,
}

darkness = obj {
	nam = 'тьма',
	dsc = [[Вокруг меня кромешная {тьма}.]],
	act = [[Очень страшно здесь находиться. Мне очень страшно...]],
}

basement_door = obj {
	nam = 'дверь погреба',
	dsc = [[Вверху открытая {дверца погреба}. ]],
	act = [[Из неё доносится очень тусклый свет. Странно, но никакой лестницы
к ней нет. Поэтому не дотянуться. Возможно лестницу кто-то специально снял.]],
}

candle = obj {
	nam = 'свеча',
	inv = [[Обычная свеча из воска. Уже использовалась, но ещё много осталось.]],
}

matchbox = obj {
	var {
		notempty = true;
	},
	nam = 'спичечный коробок',
	inv = function(s)
		if s.notempty then
			p 'В нём только одна спичка';
		else
			p 'Коробок пуст.';
		end
	end,
	use = function(s, w)
		if w == candle then
			if s.notempty then
				put('closet', 'basement');
				s.notempty = false;
				p [[Я зажёг спичку, поднёс к свече. Однако внезапно
воздух дёрнулся, и... спичка погасла. Я успел лишь заметить шкаф в комнате. Там может
быть лестница. Правда на шкафу замок.]];
			else
				p 'Коробок пуст.';
			end
		end
	end,
}

fork = obj {
	nam = 'вилка',
	inv = [[Алюминиевая пищевая вилка. Может ещё пригодится.]],
}

table = obj {
	var {
		searched = false;
	},
	nam = 'стол',
	dsc = [[В углу еле заметен {стол}.]],
	act = function(s)
		p 'На ощупь деревянный.';
		if s.searched then
			p 'Ничего больше нет.';
		else
			p 'Обыскиваю стол руками. О! Нашёл свечку, спичечный коробок и вилку!';
			take('candle');
			take('matchbox');
			take('fork');
			s.searched = true;
		end
	end,
}

rope = obj {
	nam = 'верёвка',
	inv = [[Верёвка. На одном конце есть металлический крюк.]],
	use = function(s, w)
		if w == basement_door then
			p 'Мне удалось крюк верёвки зацепить за петлю и выбраться из погреба.';
			walk(build_kitchen);
		end
	end,
}

radio = obj {
	var {
		listened = false;
	},
	nam = 'радиоприёмник',
	inv = function(s)
		if here() == basement then
			p 'Я включил радиоприёмник. Однако кроме помех ничего не услышал. Видимо, плохой приём.';
		else
			s.listened = true;
			p [[Мне удалось поймать волну!^^
"... Только особи, которые... безопасны... это могут быть особи, которые были вегетарианцами...
до конца это явление не изучено... однако ни одна заражённая особь, которая кидалась на
растительность... вроде коры дерева, не нападала на человека... Особей, которые проявляют хоть малейшую агрессию по отношению
к человеку... ликвидировать..."^^
Что за бред?!]];
		end
	end,
}

closet = obj {
	var {
		opened = false;
		searched = false;
	},
	nam = 'шкаф',
	dsc = [[В другой части комнаты стоит {шкаф}.]],
	act = function(s)
		if s.opened then
			if s.searched then
				p 'Больше ничего нет интересного.';
			else
				take('rope');
				take('radio');
				s.searched = true;
				p 'Я на ощупь нашёл верёвку и радиоприёмник.';
			end
		else
			p 'Я его заметил, когда пытался зажечь свечку. На нём весит небольшой замок.';
		end
	end,
	used = function(s, w)
		if w == gun then
			s.opened = true;
			p 'Я выстрелил в замок. Он свалился. Шкаф открыт.';
		end
	end
}

pot = obj {
	nam = 'кастрюля',
	dsc = [[На полу стоит {кастрюля}.]],
	act = [[Вот она! Из-за неё я упал!]];
}

goto_hayloft = obj {
	nam = 'к сеновалу',
	dsc = [[{Пойти к сеновалу.}]],
	act = code[[walk(hayloft_screen)]];
}

build_kitchen = room {
	nam = 'Кухня',
	dsc = [[Кухня. Это точно кухня.]],
	obj = {'pot'},
}

hayloft_screen = room {
	nam = 'Сеновал',
	dsc = [[Сеновал действительно оказался за домом. И там я встретил людей.
Один из низ воскликнул:^^
-- Пашка! Ну где ты пропадал?! Дружбан!^^
Вдруг вмешался другой:^^
-- Рука!!! Он заражён! Убейте его!^^
Ещё двое схватили дробовики и нацелились на меня. Тот первый стал передо мной закрывая.^^
-- Стойте! У нас же в лаборатории есть противоядие! Это же Пашка!^^
-- Нельзя рисковать! Убъём!!!^^
Они начали спорить. А я вдруг задумался. Я всё понял. Я превращаюсь в зомби. Меня заразили.
Моя рука... Как я раньше не заметил. На ней укус. Память... Она пропала. Я не человек...
Но я хочу жить...^^
{start_hayloft|Продолжить}.]],
	obj = {
		xact('start_hayloft', code[[walk(hayloft)]]),
	},
	enter = function()
		set_music('music/hayloft.ogg');
	end,
}

people = obj {
	nam = 'люди',
	dsc = [[Передо мной спорят {люди}.]],
	act = [[Они решают убивать меня или нет.]],
}

log = obj {
	nam = 'бревно',
	dsc = [[Слева лежит {бревно}.]],
	act = [[Свежее. Не так давно срублено. Зачем оно? Чтобы сидеть?]],
	used = function(s, w)
		if w == fork and radio.listened then
			p 'Вилка, бревно...';
			walk(log_eat_screen);
		end
	end,
}

run_away = obj {
	nam = 'убежать',
	dsc = [[Можно попытаться {убежать}.]],
	act = code[[walk(bad_end)]],
}

hayloft = room {
	nam = 'Сеновал',
	dsc = [[Сеновал. Довольно просторный сарай с сеном.]],
	obj = {'people', 'log', 'run_away'},
}

bad_end = room {
	nam = 'Конец',
	dsc = [[Я попытался убежать. Но раздались выстрелы. Я упал...^^
{back_hayloft|Переиграть}.]],
	obj = {
		xact('back_hayloft', code[[walk(hayloft)]]),
	},
}

log_eat_screen = room {
	nam = 'Бревно';
	dsc = [[Я схватил вилку и начал ей отколупывать кору бревна и есть её.
Тот первый из них закричал:^^
-- Видите! Он безопасен! Он проявляет агрессию к бревну! К коре дерева!^^
Послышались возражения, но я продолжал активно пытаться есть кору бревна.^^
Меня {goto_happy_end|оглушили ударом по голове}.]],
	obj = {xact('goto_happy_end', code[[walk(happy_end);]])},
	enter = function()
		set_music('music/memory.ogg');
	end,
}

happy_end = room {
	nam = 'Конец',
	dsc = [[Я проснулся в больничной палате. Моя память была на месте.
Передо мной сидел Иван. Он улыбался. Из его глаз текли слёзы. Я всё понял.
Он спас меня. Мне дали противоядие.^^
Мы молчали минут пять. Потом он сказал:^^
-- Круто ты с бревном придумал. Они поверили, что ты безопасен.^^
-- А я безопасен был?^^
-- Ты всех нас заразил. Но у нас было противоядие...^^
{goto_end|Конец}.]],
	obj = {xact('goto_end', code[[walk(the_end);]])},
}

the_end = room {
	nam = 'Конец',
	dsc = [[Автор: Евгений Ефремов (Jhekasoft)^^
Спасибо Instead за движок, а Вжж! за бессонную ночь :)]],
}

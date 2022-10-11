import wollok.game.*
import config.*

class Bosque{
	const arboles = #{}
	
	method agregarArbol(x,y,id){		
		arboles.add(new Arbol(index=id, x_pos=x, y_pos=x))
	}
	
	method elegirArbol(index) = arboles.asList().get(index)
}

class Arbol{
	const property index
	const property x_pos
	const property y_pos
	const property position = game.at(x_pos, y_pos)
	const property image = ("tree"+ index.toString() +".png")
}

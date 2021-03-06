require "sinatra"
require "digest/sha1"


listaCorreos = []
requestHechos = []
# arma el home
get '/' do
'<form method="POST" action="/test">
  <p>Your email:<input type="text" name="name"></p>
  <p>Api Key:<input type="text" name="api"></p>
  <p>Sentence:<input type="text" name="sentence"></p>
  <input type="submit">
</form>
<form method="POST" action="/verTabla">
  <p>Ver los request</p>
  <input type="submit">
</form>'
end
#Solicita la tabla de los request hechos

post '/verTabla'do
	tablaRequest(listaCorreos)

end

# verifica los user y los api keys, verifica si no existe el correo si no entonces verfica el api y le hace match
post '/test' do
	correo = params[:name] 
	api = params[:api] 
	oracion = params[:sentence] 
	if listaCorreos.include? correo
		posi = listaCorreos.index(correo)
		apiLi = listaCorreos[posi+1]
		 
		if api == apiLi
			listaCorreos[posi+2]+=1
			retornar = '{
				  "code":"200",
				  "status":"success",
				  "duplicates":
				  {'
			retornar += contarLista(oracion)
			retornar += ' }}'
			retornar
		else
			'{
			  "code":"401",
			  "status":"unauthorized"
			}'
		end
	else
		listaCorreos+=[correo]
		apiNueva = api(correo)
		listaCorreos += [apiNueva]
		listaCorreos += [0]
		
		imprimir = 'Correo: '+correo
		imprimir += '     Api Generada: '+apiNueva
		imprimir
	end
	#api("#{params[:name]}")
  end
 
# genera api de acuerdo a sha1 y largo de 33 caracteres 
def api(correo, length = 33)
	return  Digest::SHA1.hexdigest(correo.to_s)[1..length]
end

# arma la lista de repetidos y los cuenta
def contarLista(lista)
	listaNue= lista.split(' ')
	
	countar = Hash.new(0)

	# 	iterate over the array, counting duplicate entries
	listaNue.each do |v|
	  countar[v] += 1
	end
	retornar = ""
	countar.each do |k, v|
		retornar += ("{Word: " + k+", \n\t")
		retornar += ("Position: " + (listaNue.index(k)).to_s + "," + v.to_s + "},\n")
	end
	return retornar
	
	
end
# arma la tabla de requests hechos
def tablaRequest(lista)
	imprimir = '<table style="width:45%">
			  <tr>
				<th>Correo</th>
				<th>ApiKey</th> 
				<th>Numero request</th>
			  </tr>'
		lista.each_slice(3) do |x, y, z|
			imprimir+=
			'<tr>
				<td>'+x+'</td>
				<td>'+y+'</td> 
				<td>'+z.to_s+'</td>
			  </tr>'
			
		end
	imprimir += '</table>'
	return imprimir
end
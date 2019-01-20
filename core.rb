# Because a Case is overrated
module Features
  def process(text)
    commands = {
      /archivos/ => `ls`,
      /hola/ => 'Holiwis',
      /hora/ => `date`
    }

    answer = commands.find { |key, _value| text.match? key }
    answer.last
  end
end

# AI response with the best technology available
module Intelligence
  def say(text)
    if (match = text.match(/enerai (\<[#@])?((.*)\|)?(.*?)(\>)? (.*?)$/i))
      [match.captures[2] || match.captures[3], match.captures[5]]
    else
      ['#logs', 'Meh']
    end
  end
end

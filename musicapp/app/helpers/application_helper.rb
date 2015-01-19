module ApplicationHelper
  def auth_token
    "<input type=\"hidden\"
            name=\"authenticity_token\"
            value=\"#{ form_authenticity_token }\">".html_safe
  end

  def ugly_lyrics(lyrics)
    ugly = lyrics.split("\n").map { |line| "♫ #{line}" }.join("\n")
    "<pre>#{ h(ugly) }</pre>".html_safe
  end
end

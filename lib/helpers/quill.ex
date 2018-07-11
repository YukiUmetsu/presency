defmodule Helpers.Quill do
  @moduledoc false

  def delta_to_html(gon_key \\ "post_content") do
    "var delta  =  JSON.parse(window.Gon.assets().#{gon_key});
    var config  =  {};
    var converter  =  new QuillDeltaToHtmlConverter(delta.ops, config);
    var html  =  converter.convert();"
    |> String.replace("  ", "")
    |> String.replace("\n", "")
  end

  def posts_content_to_html_array do
    """
    var data  =  window.Gon.assets();
    var posts  =  [];
    var keys = [];
    var config = {};
     Object.keys(data).forEach(function(key,index) {
      var delta  =  JSON.parse(data[key]);
      var converter  =  new QuillDeltaToHtmlConverter(delta.ops, config);
      var html  =  converter.convert();
      posts.push(html);
      keys.push(key);
    });
    """
    |> String.replace("  ", "")
    |> String.replace("\n", "")
  end
end

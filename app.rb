module Nesta
  class App
    helpers do
      
      def list_articles(articles)
        haml_tag :ol do
          articles.each do |article|
            haml_tag :li do
              haml_tag :a, article.heading, :href => path_to(article.abspath)
            end
          end
        end
      end

      def article_years
        articles = Page.find_articles
        last, first = articles[0].date.year, articles[-1].date.year
        (first..last).to_a.reverse
      end

      def archive_by_year
        article_years.each do |year|
          haml_tag :li do
            haml_tag :a, :id => "#{year}"
            haml_tag :h2, year
            haml_tag :div do
              articles = Page.find_articles.select { |a| a.date.year == year }
              list_articles(articles)
            end
          end
        end
      end

      def format_date_to_short(date)
        date.strftime("%d/%m/%Y")
      end

    end
  end
end
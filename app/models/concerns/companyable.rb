module Companyable
    extend ActiveSupport::Concern
  
    def company_type
     self.class.to_s.downcase
    end

    # TODO: beef this up with more strict criterion for being considered 'enriched'
    def enriched?
        name # && logo # && ads.count.positive? # possible a company wont have any ads
    end
end

# this should go on a standby screen, for example '/importing'
# <script>
# setInterval(checkForEnrichment(), 5000)

# function checkForEnrichment() {
#     $.ajax({
#         url: '/scraper-status',
#         success: function(data) {
#             if (data.enriched) {
#                 window.location.href = '/dashboard';
#             }
#         }
#     })
# }
# </script>
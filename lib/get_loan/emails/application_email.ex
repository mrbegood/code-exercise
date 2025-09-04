defmodule GetLoan.Emails.ApplicationEmail do
  import Swoosh.Email

  def credit_approved(application, attachment_blob) do
    new()
    |> to({application.email, application.email})
    |> from({"GetLoan", "sales@example.com"})
    |> subject("Your, credit approved!")
    |> html_body("<h1>Hello #{application.email}. Congratulations! You have been approved for credit.</h1>")
    |> text_body("Hello #{application.email}. Congratulations! You have been approved for credit.\n")
    |> attachment(
      Swoosh.Attachment.new(
        {:data, attachment_blob},
        filename: "offer-#{application.id}.pdf",
        content_type: "application/pdf",
        type: :inline
      )
    )
  end
end

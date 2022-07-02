from website import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)



"""
* Login
    * MFA?
* Sign up
    * Email
        * filter email domain
    * First Name
    * Password
    * Confirm
        * Password Complexity
* home
    * add note
    * delete note
"""
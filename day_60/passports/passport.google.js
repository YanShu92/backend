var GoogleStrategy = require("passport-google-oauth20").Strategy;
const { User } = require("../models/index");
module.exports = new GoogleStrategy(
  {
    clientID: process.env.GOOGLE_CLIENTID,
    clientSecret: process.env.GOOGLE_CLIENTSECRET,
    callbackURL: process.env.GOOGLE_CALLBACKURL,
    scope: ["email", "profile"],
  },
  async (accessToken, refreshToken, profile, done) => {
    console.log(profile);
    const { displayName: name, emails } = profile;
    const email = emails[0].value;
    const [user] = await User.findOrCreate({
      where: { email, provider_id: 2 },
      defaults: {
        name,
        email,
        provider_id: 2,
      },
    });
    console.log(user);
    done(null, user);
  }
);

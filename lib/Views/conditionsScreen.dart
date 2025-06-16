import 'package:naturascan/Utils/Widgets/backButton.dart';
import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';


class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen(
      {super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const AppBarBack(),
          title: const CustomText(
            text: "Conditions d'utilisations",
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body:  const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                CustomText(
                  fontSize: 18,
                  textAlign: TextAlign.justify,
                  text: "1. Les présentes conditions générales d’utilisation (ci-après \"CGU\") ont pour objet de définir les modalités et conditions dans lesquelles l'association Marineland de France met à disposition des utilisateurs internes l'application mobile NaturaScan, ainsi que les droits et obligations des parties dans ce cadre."
                  "\n\n2. Acceptation des conditions d’utilisation L’accès et l’utilisation de l'application NaturaScan sont soumis à l'acceptation et au respect des présentes CGU. Tout utilisateur qui accède à l'application est réputé accepter sans réserve les présentes conditions générales."
                  "\n\n3. L'application NaturaScan est exclusivement réservée à un usage interne par les membres et employés de l'association Marineland de France pour leurs sorties NaturaScan et SuiviTrace. L'utilisation de l'application à des fins autres que celles pour lesquelles elle a été conçue est formellement interdite."
                  "\n\n4. Propriété intellectuelle Les contenus de l'application (textes, images, graphismes, etc.) sont protégés par le droit d’auteur, le droit des marques et tout autre droit de propriété intellectuelle reconnu selon les lois en vigueur. Aucun de ces contenus ne peut être reproduit, modifié, transmis, vendu, exploité commercialement ou réutilisé de quelque manière que ce soit sans l'accord préalable écrit de l'association Marineland de France."
                  "\n\n5. Responsabilité L'utilisateur est seul responsable de l'utilisation de l'application et des données qu’il consulte, télécharge ou transmet à travers celle-ci. L'association Marineland de France décline toute responsabilité pour tout usage non conforme aux réglementations en vigueur ou aux présentes conditions d'utilisation."
                  "\n\n6. Modifications des conditions d’utilisation L'association Marineland de France se réserve le droit de modifier les présentes CGU à tout moment. L'utilisateur est donc invité à consulter la version la plus récente régulièrement."
                  "\n\n7. Loi applicable et juridiction Les présentes conditions générales sont régies par la loi française. En cas de litige, et après l'échec de toute tentative de recherche d'une solution amiable, les tribunaux français seront compétents pour traiter ce cas."
                  "\n\n8. Pour toute question relative à l'application NaturaScan, veuillez contacter le support technique de l'association Marineland de France"
                  "\n\nCe modèle est assez générique et devrait être adapté en fonction des spécificités de l'application et des exigences légales applicables. Assurez-vous de consulter un juriste pour finaliser les CGU afin de garantir leur conformité avec les lois en vigueur."
                  )
              ],
            ),
          ),
        )
        );
  }

}

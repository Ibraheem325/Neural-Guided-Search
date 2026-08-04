(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star13 - direction
	Star14 - direction
	GroundStation15 - direction
	Star16 - direction
	Star17 - direction
	Star18 - direction
	Star19 - direction
	GroundStation21 - direction
	Star22 - direction
	Star23 - direction
	GroundStation24 - direction
	Star25 - direction
	Star26 - direction
	GroundStation27 - direction
	GroundStation28 - direction
	Star29 - direction
	Star30 - direction
	GroundStation31 - direction
	GroundStation32 - direction
	GroundStation33 - direction
	Star34 - direction
	Star35 - direction
	GroundStation36 - direction
	Star39 - direction
	GroundStation40 - direction
	Star41 - direction
	Star43 - direction
	GroundStation44 - direction
	Star46 - direction
	GroundStation49 - direction
	Star50 - direction
	GroundStation52 - direction
	Star54 - direction
	GroundStation55 - direction
	Star57 - direction
	Star58 - direction
	Star59 - direction
	GroundStation60 - direction
	Star61 - direction
	GroundStation63 - direction
	GroundStation64 - direction
	Star65 - direction
	Star66 - direction
	GroundStation67 - direction
	Star68 - direction
	GroundStation69 - direction
	GroundStation70 - direction
	Star71 - direction
	GroundStation7 - direction
	GroundStation12 - direction
	Star48 - direction
	GroundStation56 - direction
	Star53 - direction
	GroundStation51 - direction
	Star37 - direction
	GroundStation62 - direction
	Star20 - direction
	GroundStation38 - direction
	Star45 - direction
	Star2 - direction
	Star9 - direction
	GroundStation42 - direction
	GroundStation47 - direction
	Planet72 - direction
	Planet73 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation47)
	(calibration_target instrument0 GroundStation42)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 Star45)
	(calibration_target instrument0 GroundStation38)
	(calibration_target instrument0 Star20)
	(calibration_target instrument0 GroundStation62)
	(calibration_target instrument0 Star37)
	(calibration_target instrument0 GroundStation51)
	(calibration_target instrument0 Star53)
	(calibration_target instrument0 GroundStation56)
	(calibration_target instrument0 Star48)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation52)
)
(:goal (and
	(have_image Planet72 image0)
	(have_image Planet73 image0)
))

)

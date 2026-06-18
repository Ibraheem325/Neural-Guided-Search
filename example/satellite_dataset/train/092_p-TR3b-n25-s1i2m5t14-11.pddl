(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image2 - mode
	thermograph0 - mode
	spectrograph3 - mode
	thermograph4 - mode
	Star2 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star6 - direction
	Star3 - direction
	Star0 - direction
	GroundStation1 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 image2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star14)
)
(:goal (and
	(pointing satellite0 Star6)
	(have_image Star14 spectrograph3)
	(have_image Star15 spectrograph1)
	(have_image Planet16 thermograph4)
	(have_image Phenomenon17 spectrograph1)
))

)
